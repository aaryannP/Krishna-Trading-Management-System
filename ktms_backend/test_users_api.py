import requests

url = "http://127.0.0.1:8000/api/v1/users/"
response = requests.get(url)
print("Status Code:", response.status_code)
print("Response JSON:")
print(response.json())
