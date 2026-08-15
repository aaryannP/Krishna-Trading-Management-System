import requests

base_url = "http://127.0.0.1:8000/api/v1"

# 1. Register new email
res_reg = requests.post(f"{base_url}/auth/register/", json={
    "email": "testotp99@gmail.com",
    "password": "Password@123",
    "confirm_password": "Password@123",
    "first_name": "Test",
    "last_name": "OTP",
    "mobile": "9988776655",
    "role": "RETAIL_CUSTOMER"
})

print("1. Registration Status:", res_reg.status_code)
data = res_reg.json()
otp_generated = data.get("demo_otp")
print("🔥 GENERATED RANDOM OTP FOR testotp99@gmail.com IS:", otp_generated)

# 2. Try wrong OTP (e.g. 000000)
res_wrong = requests.post(f"{base_url}/auth/verify-otp/", json={
    "email": "testotp99@gmail.com",
    "otp": "000000"
})
print("\n2. Wrong OTP Status:", res_wrong.status_code, "| Message:", res_wrong.json().get("message"))

# 3. Verify exact generated OTP
res_correct = requests.post(f"{base_url}/auth/verify-otp/", json={
    "email": "testotp99@gmail.com",
    "otp": otp_generated
})
print("\n3. Correct Random OTP Verification Status:", res_correct.status_code, "| Message:", res_correct.json().get("message"))
