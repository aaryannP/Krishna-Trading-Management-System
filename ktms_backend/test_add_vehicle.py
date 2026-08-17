import os, sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')

import django
django.setup()

from rest_framework.test import APIRequestFactory
from fleet.views import FleetVehicleListAPIView

factory = APIRequestFactory()
request = factory.post('/api/v1/fleet/vehicles/', {
    'asset_name': 'Bike',
    'purchase_cost': 95000.0,
    'registration_no': 'GJ-27-BR-2624',
    'vehicle_type': 'ACTIVA',
    'payload_capacity_kg': 50.0
}, format='json')

view = FleetVehicleListAPIView.as_view()
response = view(request)

print("Status Code:", response.status_code)
print("Response Data:", response.data)
