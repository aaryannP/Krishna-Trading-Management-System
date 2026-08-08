from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone
import datetime

class UserRole(models.TextChoices):
    SUPER_ADMIN = 'SUPER_ADMIN', 'Super Admin'
    GENERAL_MANAGER = 'GENERAL_MANAGER', 'General Manager'
    FLEET_MANAGER = 'FLEET_MANAGER', 'Fleet Manager'
    STAFF = 'STAFF', 'Shop / Warehouse Staff'
    DRIVER = 'DRIVER', 'Driver / Logistics Staff'
    RETAIL_CUSTOMER = 'RETAIL_CUSTOMER', 'Retail B2C Customer'
    WHOLESALE_CUSTOMER = 'WHOLESALE_CUSTOMER', 'Wholesale B2B Customer'

class CustomUser(AbstractUser):
    role = models.CharField(max_length=30, choices=UserRole.choices, default=UserRole.RETAIL_CUSTOMER)
    mobile = models.CharField(max_length=20, unique=True, null=True, blank=True)
    dob = models.DateField(null=True, blank=True)
    aadhaar_no = models.CharField(max_length=20, null=True, blank=True)
    license_no = models.CharField(max_length=50, null=True, blank=True)
    admin_security_key = models.CharField(max_length=100, null=True, blank=True)
    is_frozen = models.BooleanField(default=False)
    frozen_until = models.DateTimeField(null=True, blank=True)

    def generate_admin_security_key(self, last_name, mobile, birth_year):
        last_name_4 = (last_name or 'ADMIN')[:4].upper()
        mobile_4 = (mobile or '0000')[-4:]
        year = str(birth_year or '2000')
        self.admin_security_key = f"{last_name_4}{mobile_4}{year}"
        return self.admin_security_key

    def __str__(self):
        return f"{self.username} ({self.role})"

class SuspiciousActivity(models.Model):
    identifier = models.CharField(max_length=255, db_index=True) # Email, Mobile, or IP
    failed_attempts = models.IntegerField(default=1)
    blocked_until = models.DateTimeField(null=True, blank=True)
    reason = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    def is_currently_blocked(self):
        if self.blocked_until and timezone.now() < self.blocked_until:
            return True
        return False

    def remaining_seconds(self):
        if self.blocked_until and timezone.now() < self.blocked_until:
            return int((self.blocked_until - timezone.now()).total_seconds())
        return 0

    def __str__(self):
        return f"{self.identifier} - Blocked: {self.is_currently_blocked()}"

class WholesaleStatus(models.TextChoices):
    PENDING = 'PENDING', 'Pending Verification'
    VERIFIED = 'VERIFIED', 'Verified B2B Account'
    REJECTED = 'REJECTED', 'Verification Rejected'

class WholesaleProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='wholesale_profile')
    company_name = models.CharField(max_length=255)
    gstin = models.CharField(max_length=20, unique=True)
    credit_limit = models.DecimalField(max_digits=12, decimal_places=2, default=500000.00)
    credit_days = models.IntegerField(default=30)
    verification_status = models.CharField(max_length=20, choices=WholesaleStatus.choices, default=WholesaleStatus.PENDING)
    gst_certificate_url = models.CharField(max_length=500, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.company_name} ({self.gstin}) - {self.verification_status}"

