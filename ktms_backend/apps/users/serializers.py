# pyrefly: ignore [missing-import]
from rest_framework import serializers
from users.models import CustomUser, WholesaleProfile, SuspiciousActivity, UserRole, WholesaleStatus

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'mobile', 'first_name', 'last_name', 'role', 'dob', 'aadhaar_no', 'license_no', 'is_frozen', 'frozen_until', 'date_joined']

class WholesaleProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    class Meta:
        model = WholesaleProfile
        fields = ['id', 'user', 'company_name', 'gstin', 'credit_limit', 'credit_days', 'verification_status', 'gst_certificate_url', 'created_at']

class RegistrationSerializer(serializers.Serializer):
    role = serializers.ChoiceField(choices=UserRole.choices)
    first_name = serializers.CharField(max_length=100)
    last_name = serializers.CharField(max_length=100)
    email = serializers.EmailField()
    dob = serializers.DateField(required=False, allow_null=True)
    mobile = serializers.CharField(max_length=20, required=False, allow_blank=True)
    phone_number = serializers.CharField(max_length=20, required=False, allow_blank=True)
    password = serializers.CharField(min_length=6, write_only=True)
    confirm_password = serializers.CharField(min_length=6, required=False, allow_blank=True, write_only=True)
    admin_passkey = serializers.CharField(required=False, allow_blank=True)

    def validate(self, data):
        # Normalize mobile / phone_number
        mobile_val = data.get('mobile') or data.get('phone_number', '9999999999')
        data['mobile'] = mobile_val

        # Normalize confirm_password
        if 'confirm_password' not in data or not data['confirm_password']:
            data['confirm_password'] = data['password']

        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError({"password": "Password and Confirm Password do not match."})
        
        # Security Rule: Public signup role isolation
        if data['role'] in [UserRole.SUPER_ADMIN, UserRole.GENERAL_MANAGER, UserRole.FLEET_MANAGER, UserRole.STAFF, UserRole.DRIVER]:
            from django.conf import settings
            admin_key = data.get('admin_passkey', '')
            if admin_key != getattr(settings, 'ADMIN_MASTER_PASSKEY', ''):
                raise serializers.ValidationError({"admin_passkey": "Invalid Admin Master Passkey. Staff roles cannot register publicly."})
        
        if CustomUser.objects.filter(email=data['email']).exists():
            raise serializers.ValidationError({"email": "User with this email already exists."})
        if CustomUser.objects.filter(mobile=data['mobile']).exists():
            raise serializers.ValidationError({"mobile": "User with this mobile number already exists."})
            
        return data

class VerifyOTPSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)

class LoginSerializer(serializers.Serializer):
    email = serializers.CharField(required=False, allow_blank=True)
    username = serializers.CharField(required=False, allow_blank=True)
    password = serializers.CharField(write_only=True)
    admin_security_key = serializers.CharField(required=False, allow_blank=True)

class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()

class ResetPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)
    new_password = serializers.CharField(min_length=6, write_only=True)
    confirm_password = serializers.CharField(min_length=6, write_only=True)

    def validate(self, data):
        if data['new_password'] != data['confirm_password']:
            raise serializers.ValidationError({"new_password": "New passwords do not match."})
        return data
