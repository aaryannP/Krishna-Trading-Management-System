from django.urls import path
from assets.views import (
    AssetListCreateAPIView,
    AssetDashboardAPIView,
    AssetAssignmentAPIView,
    AssetMaintenanceAPIView
)

urlpatterns = [
    path('assets/', AssetListCreateAPIView.as_view(), name='api_asset_list_create'),
    path('assets/dashboard/', AssetDashboardAPIView.as_view(), name='api_asset_dashboard'),
    path('assets/assignments/', AssetAssignmentAPIView.as_view(), name='api_asset_assignments'),
    path('assets/maintenance/', AssetMaintenanceAPIView.as_view(), name='api_asset_maintenance'),
]
