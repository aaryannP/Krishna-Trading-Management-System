import os
import sys
import django

sys.path.insert(0, r"c:\Projects\ktms_backend")
sys.path.insert(0, r"c:\Projects\ktms_backend\apps")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
django.setup()

from users.models import CustomUser, UserRole, WholesaleProfile, WholesaleStatus
import random

try:
    print("Testing direct CustomUser creation...")
    email = "clienttest1@gmail.com"
    user_mobile = "9876543210"
    if CustomUser.objects.filter(mobile=user_mobile).exists():
        user_mobile = f"{user_mobile[:5]}{random.randint(10000, 99999)}"

    if not CustomUser.objects.filter(email=email).exists():
        user = CustomUser.objects.create_user(
            username=email,
            email=email,
            password="Password@123",
            first_name="Client",
            last_name="Test",
            role=UserRole.WHOLESALE_CUSTOMER,
            mobile=user_mobile
        )
        print("SUCCESSFULLY CREATED USER:", user.id, user.username)
        if user.role == UserRole.WHOLESALE_CUSTOMER:
            WholesaleProfile.objects.create(
                user=user,
                company_name=f"{user.first_name}'s Business",
                gstin=f"24{random.randint(1000000000, 9999999999)}A1Z5",
                verification_status=WholesaleStatus.PENDING
            )
            print("SUCCESSFULLY CREATED WHOLESALE PROFILE!")
    else:
        print("User with email already exists!")
except Exception as e:
    import traceback
    traceback.print_exc()
