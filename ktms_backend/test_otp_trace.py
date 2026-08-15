import os
import sys
import django

sys.path.insert(0, r"c:\Projects\ktms_backend")
sys.path.insert(0, r"c:\Projects\ktms_backend\apps")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
django.setup()

from rest_framework.test import APIRequestFactory
from users.views import RegisterAPIView

factory = APIRequestFactory()
request = factory.post('/api/v1/auth/register/', {
    "email": "randomotp99@gmail.com",
    "password": "Password@123",
    "confirm_password": "Password@123",
    "first_name": "Random",
    "last_name": "OTP",
    "mobile": "9911223344",
    "role": "RETAIL_CUSTOMER"
}, format='json')

view = RegisterAPIView.as_view()
response = view(request)
print("Response Status:", response.status_code)
print("Response Data:", response.data)
