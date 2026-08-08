from django.urls import path
from users.views import RegisterAPIView, VerifyOTPAPIView, LoginAPIView, AddPersonAPIView, UserListAPIView

urlpatterns = [
    path('auth/register/', RegisterAPIView.as_view(), name='api_register'),
    path('auth/verify-otp/', VerifyOTPAPIView.as_view(), name='api_verify_otp'),
    path('auth/login/', LoginAPIView.as_view(), name='api_login'),
    path('users/', UserListAPIView.as_view(), name='api_user_list'),
    path('users/add-person/', AddPersonAPIView.as_view(), name='api_add_person'),
]

