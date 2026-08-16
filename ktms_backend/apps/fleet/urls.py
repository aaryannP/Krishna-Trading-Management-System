from django.urls import path
from fleet.views import (
    FleetDashboardAPIView,
    FleetVehicleListAPIView,
    DriverListAPIView,
    TripListCreateAPIView,
    FuelLogListCreateAPIView,
    VehicleDocumentsAPIView,
    DispatchManagementAPIView,
    ReportsAnalyticsAPIView,
    SystemSettingsAPIView,
    PayloadMatcherAPIView
)

urlpatterns = [
    path('fleet/dashboard/', FleetDashboardAPIView.as_view(), name='api_fleet_dashboard'),
    path('fleet/vehicles/', FleetVehicleListAPIView.as_view(), name='api_fleet_vehicles'),
    path('fleet/drivers/', DriverListAPIView.as_view(), name='api_fleet_drivers'),
    path('fleet/trips/', TripListCreateAPIView.as_view(), name='api_fleet_trips'),
    path('fleet/fuel/', FuelLogListCreateAPIView.as_view(), name='api_fleet_fuel'),
    path('fleet/documents/', VehicleDocumentsAPIView.as_view(), name='api_fleet_documents'),
    path('fleet/dispatch/', DispatchManagementAPIView.as_view(), name='api_fleet_dispatch'),
    path('fleet/payload-matcher/', PayloadMatcherAPIView.as_view(), name='api_payload_matcher'),
    path('reports/analytics/', ReportsAnalyticsAPIView.as_view(), name='api_reports_analytics'),
    path('system/settings/', SystemSettingsAPIView.as_view(), name='api_system_settings'),
]
