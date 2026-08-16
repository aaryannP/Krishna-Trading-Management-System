from django.urls import path
from fleet.views import FleetDashboardAPIView, FleetVehicleListAPIView, PayloadMatcherAPIView

urlpatterns = [
    path('fleet/dashboard/', FleetDashboardAPIView.as_view(), name='api_fleet_dashboard'),
    path('fleet/vehicles/', FleetVehicleListAPIView.as_view(), name='api_fleet_vehicles'),
    path('fleet/payload-matcher/', PayloadMatcherAPIView.as_view(), name='api_payload_matcher'),
]
