# pyrefly: ignore [missing-import]
from rest_framework import serializers
from assets.models import Asset, AssetAssignment, AssetMaintenance, AssetCategory, AssetStatus
from users.serializers import UserSerializer

class AssetSerializer(serializers.ModelSerializer):
    category_display = serializers.CharField(source='get_category_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = Asset
        fields = [
            'id', 'asset_code', 'name', 'category', 'category_display',
            'model_no', 'serial_no', 'purchase_date', 'purchase_cost',
            'status', 'status_display'
        ]

class AssetAssignmentSerializer(serializers.ModelSerializer):
    asset_detail = AssetSerializer(source='asset', read_only=True)
    user_detail = UserSerializer(source='user', read_only=True)

    class Meta:
        model = AssetAssignment
        fields = [
            'id', 'asset', 'asset_detail', 'user', 'user_detail',
            'assigned_by', 'assigned_date', 'return_date', 'notes', 'is_active'
        ]

class AssetMaintenanceSerializer(serializers.ModelSerializer):
    asset_detail = AssetSerializer(source='asset', read_only=True)

    class Meta:
        model = AssetMaintenance
        fields = [
            'id', 'asset', 'asset_detail', 'service_type', 'service_date',
            'cost', 'vendor_name', 'status'
        ]
