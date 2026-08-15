import requests
import random

base_url = "http://127.0.0.1:8000/api/v1"

print("==================================================")
print("*** E2E EMPIRICAL VERIFICATION OF AUTH SUITE ***")
print("==================================================")

# 1. Test Registration
test_email = f"finaltest_{random.randint(1000, 9999)}@gmail.com"
test_phone = f"987{random.randint(1000000, 9999999)}"

print(f"\n[STEP 1] Registering New User: {test_email}...")
reg_res = requests.post(f"{base_url}/auth/register/", json={
    "email": test_email,
    "password": "Password@123",
    "confirm_password": "Password@123",
    "first_name": "Final",
    "last_name": "Test",
    "mobile": test_phone,
    "role": "WHOLESALE_CUSTOMER"
})

assert reg_res.status_code == 200, f"Registration Failed: {reg_res.text}"
otp_code = reg_res.json().get("demo_otp")
print(f"[SUCCESS] Registration Success! Generated OTP Code: {otp_code}")

# 2. Test OTP Verification
print(f"\n[STEP 2] Verifying OTP ({otp_code}) for {test_email}...")
verify_res = requests.post(f"{base_url}/auth/verify-otp/", json={
    "email": test_email,
    "otp": otp_code
})

assert verify_res.status_code in [200, 201], f"OTP Verification Failed: {verify_res.text}"
print(f"[SUCCESS] OTP Verification Success! Server Response: {verify_res.json().get('message')}")

# 3. Test Login with Email
print(f"\n[STEP 3] Testing Login with Email ({test_email})...")
login_email_res = requests.post(f"{base_url}/auth/login/", json={
    "username": test_email,
    "password": "Password@123"
})

assert login_email_res.status_code == 200, f"Login with Email Failed: {login_email_res.text}"
print(f"[SUCCESS] Login with Email Success! User ID: {login_email_res.json().get('user', {}).get('id')}")

# 4. Test Login with Username (Email Prefix)
derived_uname = test_email.split('@')[0]
print(f"\n[STEP 4] Testing Login with Derived Username ({derived_uname})...")
login_uname_res = requests.post(f"{base_url}/auth/login/", json={
    "username": derived_uname,
    "password": "Password@123"
})

assert login_uname_res.status_code == 200, f"Login with Username Failed: {login_uname_res.text}"
print(f"[SUCCESS] Login with Username Success! User ID: {login_uname_res.json().get('user', {}).get('id')}")

print("\n==================================================")
print("ALL 4 STEPS PASSED 100% CLEAN & FLAWLESS!")
print("==================================================")
