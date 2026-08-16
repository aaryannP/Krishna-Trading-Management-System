import requests

url = "http://127.0.0.1:8000/api/v1/assets/"
try:
    response = requests.get(url)
    print("GET Status Code:", response.status_code)
    print("GET Response JSON:", response.json())
except Exception as e:
    print("GET Exception:", e)

payload = {
    "name": "Test Sewing Machine",
    "category": "MACHINE",
    "purchase_cost": "15000.00"
}
try:
    response = requests.post(url, json=payload)
    print("POST Status Code:", response.status_code)
    print("POST Response JSON:", response.json())
except Exception as e:
    print("POST Exception:", e)
