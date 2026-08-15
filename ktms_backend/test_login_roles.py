import requests

base_url = "http://127.0.0.1:8000/api/v1"

print("--- 1. TESTING SUPER_ADMIN WITHOUT KEY ---")
res1 = requests.post(f"{base_url}/auth/login/", json={
    "username": "admin",
    "password": "Admin@123"
})
print("Status:", res1.status_code, "| Response:", res1.json().get("message"))

print("\n--- 2. TESTING SUPER_ADMIN WITH KEY ---")
res2 = requests.post(f"{base_url}/auth/login/", json={
    "username": "admin",
    "password": "Admin@123",
    "admin_security_key": "PARM81492004"
})
print("Status:", res2.status_code, "| Message:", res2.json().get("message"), "| User Role:", res2.json().get("user", {}).get("role"))

print("\n--- 3. TESTING GENERAL_MANAGER WITHOUT KEY ---")
res3 = requests.post(f"{base_url}/auth/login/", json={
    "username": "manager@krishnatrading.com",
    "password": "Manager@123"
})
print("Status:", res3.status_code, "| Message:", res3.json().get("message"), "| User Role:", res3.json().get("user", {}).get("role"))

print("\n--- 4. TESTING FLEET_MANAGER WITHOUT KEY ---")
res4 = requests.post(f"{base_url}/auth/login/", json={
    "username": "fleet@krishnatrading.com",
    "password": "Fleet@123"
})
print("Status:", res4.status_code, "| Message:", res4.json().get("message"), "| User Role:", res4.json().get("user", {}).get("role"))
