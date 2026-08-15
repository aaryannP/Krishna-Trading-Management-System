import requests

url = "http://127.0.0.1:8000/api/v1/auth/register/"
res = requests.post(url, json={
    "email": "vijay55@gmail.com",
    "password": "Password@123",
    "confirm_password": "Password@123",
    "first_name": "Vijay",
    "last_name": "Parmar",
    "mobile": "9812345678",
    "role": "RETAIL_CUSTOMER"
})

print("Registration Status:", res.status_code)
print("Registration Response:", res.json())
