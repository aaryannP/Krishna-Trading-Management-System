import requests

base_url = "http://127.0.0.1:8000/api/v1"

# 1. Verify OTP for vijay55@gmail.com
res_otp = requests.post(f"{base_url}/auth/verify-otp/", json={
    "email": "vijay55@gmail.com",
    "otp": "123456"
})
print("OTP Status:", res_otp.status_code, "| Message:", res_otp.json().get("message"))

# 2. Try Login with full email 'vijay55@gmail.com'
res_login_email = requests.post(f"{base_url}/auth/login/", json={
    "username": "vijay55@gmail.com",
    "password": "Password@123"
})
print("Login with Email Status:", res_login_email.status_code, "| User:", res_login_email.json().get("user", {}).get("username"))

# 3. Try Login with derived username 'vijay55' (without @gmail.com)
res_login_user = requests.post(f"{base_url}/auth/login/", json={
    "username": "vijay55",
    "password": "Password@123"
})
print("Login with Derived Username Status:", res_login_user.status_code, "| User:", res_login_user.json().get("user", {}).get("username"))
