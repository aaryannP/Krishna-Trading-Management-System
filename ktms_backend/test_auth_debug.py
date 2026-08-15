import requests
import json

base_url = "http://127.0.0.1:8000/api/v1"

print("--- TESTING LOGIN WITH USERNAME ---")
res_login1 = requests.post(f"{base_url}/auth/login/", json={
    "email": "admin",
    "username": "admin",
    "password": "Admin@123",
    "admin_security_key": "PARM81492004"
})
print("Login Status:", res_login1.status_code)
print("Login Response:", res_login1.text)

print("\n--- TESTING LOGIN WITH EMAIL ---")
res_login2 = requests.post(f"{base_url}/auth/login/", json={
    "email": "admin@krishnatrading.com",
    "username": "admin@krishnatrading.com",
    "password": "Admin@123",
    "admin_security_key": "PARM81492004"
})
print("Login Status:", res_login2.status_code)
print("Login Response:", res_login2.text)

print("\n--- TESTING REGISTRATION ---")
res_reg = requests.post(f"{base_url}/auth/register/", json={
    "username": "clienttest1",
    "email": "clienttest1@gmail.com",
    "first_name": "Client",
    "last_name": "Test",
    "mobile": "9876543210",
    "phone_number": "9876543210",
    "password": "Password@123",
    "confirm_password": "Password@123",
    "role": "WHOLESALE_CUSTOMER"
})
print("Reg Status:", res_reg.status_code)
print("Reg Response:", res_reg.text)
