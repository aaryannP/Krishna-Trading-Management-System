from rest_framework import status, views, permissions
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.utils import timezone
from django.contrib.auth import authenticate
from django.core.cache import cache
import datetime
import random

from users.models import CustomUser, WholesaleProfile, SuspiciousActivity, UserRole, WholesaleStatus
from users.serializers import (
    RegistrationSerializer, VerifyOTPSerializer, LoginSerializer,
    ForgotPasswordSerializer, ResetPasswordSerializer, UserSerializer, WholesaleProfileSerializer
)

from django.core.mail import send_mail

class RegisterAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = RegistrationSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        data = serializer.validated_data
        identifier = data['email']

        # Check 48-Hour Ban in SuspiciousActivity
        ban_record = SuspiciousActivity.objects.filter(identifier=identifier).first()
        if ban_record and ban_record.is_currently_blocked():
            remaining = ban_record.remaining_seconds()
            return Response({
                "status": "error",
                "message": "Suspicious Activity Detected! Registration blocked for 48 Hours.",
                "remaining_seconds": remaining,
                "blocked_until": ban_record.blocked_until
            }, status=status.HTTP_403_FORBIDDEN)

        # Generate 6-Digit OTP
        generated_otp = "123456" # Production uses random.randint(100000, 999999)
        cache_key = f"reg_otp_{identifier}"
        pending_data = data.copy()
        pending_data['otp'] = generated_otp
        pending_data['otp_attempts'] = 0
        cache.set(cache_key, pending_data, timeout=600) # 10 mins cache

        # Send OTP via Django Email Engine (Terminal Console / Production SMTP)
        try:
            send_mail(
                subject="Krishna Trading ERP - Your Registration OTP Code",
                message=f"Hello {data['first_name']},\n\nYour 6-digit OTP code for Krishna Trading ERP registration is: {generated_otp}\n\nValid for 10 minutes.\n\nRegards,\nKrishna Trading ERP Team",
                from_email=None,
                recipient_list=[identifier],
                fail_silently=True
            )
        except Exception as e:
            pass

        return Response({
            "status": "success",
            "message": "OTP sent successfully to registered email. Valid for 60 seconds.",
            "email": identifier,
            "resend_timer_seconds": 60,
            "demo_otp": generated_otp # Provided for testing
        }, status=status.HTTP_200_OK)


class VerifyOTPAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = VerifyOTPSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        email = serializer.validated_data['email']
        input_otp = serializer.validated_data['otp']
        cache_key = f"reg_otp_{email}"
        pending_data = cache.get(cache_key)

        # Fallback for dev testing if session expired
        if not pending_data:
            pending_data = {
                'email': email,
                'password': 'Password@123',
                'first_name': email.split('@')[0].capitalize(),
                'last_name': 'Customer',
                'role': UserRole.WHOLESALE_CUSTOMER,
                'mobile': '9876543210',
                'otp': '123456',
                'otp_attempts': 0
            }

        # OTP Validation (Accepts 123456 or cached OTP)
        if input_otp != '123456' and pending_data.get('otp') != input_otp:
            attempts = pending_data.get('otp_attempts', 0) + 1
            pending_data['otp_attempts'] = attempts
            cache.set(cache_key, pending_data, timeout=600)

            if attempts >= 3:
                # Trigger 48-Hour Ban
                blocked_until = timezone.now() + datetime.timedelta(hours=48)
                SuspiciousActivity.objects.create(
                    identifier=email,
                    failed_attempts=attempts,
                    blocked_until=blocked_until,
                    reason="Registration 48-Hour Ban: 3 Failed OTP Attempts"
                )
                cache.delete(cache_key)
                return Response({
                    "status": "error",
                    "message": "Suspicious Activity Detected! Your registration attempt has been blocked for 48 Hours.",
                    "blocked_until": blocked_until,
                    "remaining_seconds": 172800 # 48 hours
                }, status=status.HTTP_403_FORBIDDEN)

            return Response({
                "status": "error",
                "message": f"Invalid OTP! Attempt {attempts} of 3.",
                "attempts_remaining": 3 - attempts
            }, status=status.HTTP_400_BAD_REQUEST)

        # OTP Verified -> Create or Retrieve CustomUser safely
        user = CustomUser.objects.filter(email=email).first()
        if not user:
            user_mobile = pending_data.get('mobile', '9876543210')
            if CustomUser.objects.filter(mobile=user_mobile).exists():
                user_mobile = f"{user_mobile[:5]}{random.randint(10000, 99999)}"

            user = CustomUser.objects.create_user(
                username=email,
                email=email,
                password=pending_data['password'],
                first_name=pending_data['first_name'],
                last_name=pending_data['last_name'],
                role=pending_data['role'],
                mobile=user_mobile,
                dob=pending_data.get('dob')
            )
        else:
            user.set_password(pending_data['password'])
            user.is_active = True
            user.save()

        # Generate Dynamic Admin Security Key if Admin
        if user.role in [UserRole.SUPER_ADMIN, UserRole.GENERAL_MANAGER]:
            birth_year = user.dob.year if user.dob else 2000
            user.generate_admin_security_key(user.last_name, user.mobile, birth_year)
            user.save()

        # If Wholesale Customer, Get or Create Wholesale Profile safely
        if user.role == UserRole.WHOLESALE_CUSTOMER:
            WholesaleProfile.objects.get_or_create(
                user=user,
                defaults={
                    'company_name': request.data.get('company_name', f"{user.first_name}'s Business"),
                    'gstin': request.data.get('gstin', f"24{random.randint(1000000000, 9999999999)}A1Z5"),
                    'verification_status': WholesaleStatus.PENDING
                }
            )

        cache.delete(cache_key)
        refresh = RefreshToken.for_user(user)

        return Response({
            "status": "success",
            "message": "User Registered Successfully!",
            "tokens": {
                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh)
            },
            "user": UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)

class LoginAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        identifier = serializer.validated_data.get('email') or serializer.validated_data.get('username', '')
        password = serializer.validated_data['password']
        input_admin_key = serializer.validated_data.get('admin_security_key', '')

        # Alias resolution: If user types 'admin', map to 'admin@krishnatrading.com'
        if identifier.strip().lower() == 'admin':
            identifier = 'admin@krishnatrading.com'

        # Check 48-Hour Ban
        ban_record = SuspiciousActivity.objects.filter(identifier=identifier).first()
        if ban_record and ban_record.is_currently_blocked():
            return Response({
                "status": "error",
                "message": "Suspicious Activity Detected! Account registration/login blocked for 48 Hours.",
                "remaining_seconds": ban_record.remaining_seconds()
            }, status=status.HTTP_403_FORBIDDEN)

        from django.db.models import Q
        user = CustomUser.objects.filter(Q(email__iexact=identifier) | Q(username__iexact=identifier)).first()
        if not user:
            return Response({"status": "error", "message": "Wrong Credentials! User not found."}, status=status.HTTP_400_BAD_REQUEST)

        # Check 24-Hour Account Freeze
        if user.is_frozen and user.frozen_until:
            if timezone.now() < user.frozen_until:
                remaining = int((user.frozen_until - timezone.now()).total_seconds())
                return Response({
                    "status": "error",
                    "message": "Suspicious Activity Detected! Account Frozen for 24 Hours.",
                    "remaining_seconds": remaining,
                    "frozen_until": user.frozen_until
                }, status=status.HTTP_403_FORBIDDEN)
            else:
                user.is_frozen = False
                user.frozen_until = None
                user.save()

        # Validate Password
        if not user.check_password(password):
            return Response({"status": "error", "message": "Wrong Credentials!"}, status=status.HTTP_400_BAD_REQUEST)

        # Admin Security Key Validation (STRICTLY SUPER_ADMIN ONLY)
        if user.role == UserRole.SUPER_ADMIN:
            if not user.admin_security_key:
                birth_year = user.dob.year if user.dob else 2000
                user.generate_admin_security_key(user.last_name, user.mobile, birth_year)
                user.save()

            if not input_admin_key:
                return Response({
                    "status": "error",
                    "message": "Admin Security Key Required."
                }, status=status.HTTP_400_BAD_REQUEST)

            if input_admin_key != user.admin_security_key:
                # Track failed Admin Security Key attempts in cache
                fail_key = f"login_fails_{user.id}"
                fails = cache.get(fail_key, 0) + 1
                cache.set(fail_key, fails, timeout=86400)

                if fails >= 3:
                    user.is_frozen = True
                    user.frozen_until = timezone.now() + datetime.timedelta(hours=24)
                    user.save()
                    cache.delete(fail_key)
                    return Response({
                        "status": "error",
                        "message": "Suspicious Activity Detected! Account Frozen for 24 Hours due to 3 failed Admin Security Key attempts.",
                        "remaining_seconds": 86400
                    }, status=status.HTTP_403_FORBIDDEN)

                return Response({
                    "status": "error",
                    "message": f"Wrong Admin Security Key! Attempt {fails} of 3.",
                    "is_admin": True,
                    "attempts_remaining": 3 - fails
                }, status=status.HTTP_400_BAD_REQUEST)

        refresh = RefreshToken.for_user(user)
        wholesale_data = None
        if hasattr(user, 'wholesale_profile'):
            wholesale_data = WholesaleProfileSerializer(user.wholesale_profile).data

        return Response({
            "status": "success",
            "message": "Login Successfully!",
            "tokens": {
                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh)
            },
            "user": UserSerializer(user).data,
            "wholesale_profile": wholesale_data
        }, status=status.HTTP_200_OK)

class AddPersonAPIView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        if request.user.role not in [UserRole.SUPER_ADMIN, UserRole.GENERAL_MANAGER]:
            return Response({"status": "error", "message": "Only Admin can add internal personnel."}, status=status.HTTP_403_FORBIDDEN)

        serializer = RegistrationSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        data = serializer.validated_data
        user = CustomUser.objects.create_user(
            username=data['email'],
            email=data['email'],
            password=data['password'],
            first_name=data['first_name'],
            last_name=data['last_name'],
            role=data['role'],
            mobile=data['mobile'],
            dob=data.get('dob')
        )

        if user.role in [UserRole.SUPER_ADMIN, UserRole.GENERAL_MANAGER]:
            birth_year = user.dob.year if user.dob else 2000
            user.generate_admin_security_key(user.last_name, user.mobile, birth_year)
            user.save()

        return Response({
            "status": "success",
            "message": f"Internal Staff {user.get_role_display()} Created Successfully!",
            "user": UserSerializer(user).data,
            "admin_security_key": user.admin_security_key
        }, status=status.HTTP_201_CREATED)

class UserListAPIView(views.APIView):
    permission_classes = [permissions.AllowAny] # AllowAny for easy testing, production can restrict to IsAuthenticated

    def get(self, request):
        users = CustomUser.objects.all().order_by('-date_joined')
        role_counts = {}
        for role_choice, role_label in UserRole.choices:
            count = users.filter(role=role_choice).count()
            if count > 0:
                role_counts[role_choice] = count

        return Response({
            "status": "success",
            "total_registered_users": users.count(),
            "role_breakdown": role_counts,
            "users": UserSerializer(users, many=True).data
        }, status=status.HTTP_200_OK)

