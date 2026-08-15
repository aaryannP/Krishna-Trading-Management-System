import requests

url = "http://127.0.0.1:8000/api/v1/auth/verify-otp/"
res = requests.post(url, json={
    "email": "clienttest1@gmail.com",
    "otp": "123456"
})

print("OTP Verification Status:", res.status_code)
print("OTP Verification Response:", res.text)
