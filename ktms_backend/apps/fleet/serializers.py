# pyrefly: ignore [missing-import]
from rest_framework import serializers
from fleet.models import FleetVehicle, FleetTrip, FuelLog, VehicleType, TripStatus
from assets.serializers import AssetSerializer
from users.serializers import UserSerializer

class FleetVehicleSerializer(serializers.ModelSerializer):
    asset_detail = AssetSerializer(source='asset', read_only=True)
    vehicle_type_display = serializers.CharField(source='get_vehicle_type_display', read_only=True)

    class Meta:
        model = FleetVehicle
        fields = [
            'id', 'asset', 'asset_detail', 'registration_no', 'vehicle_type',
            'vehicle_type_display', 'payload_capacity_kg', 'puc_expiry',
            'insurance_expiry', 'fitness_expiry'
        ]

class FleetTripSerializer(serializers.ModelSerializer):
    vehicle_detail = FleetVehicleSerializer(source='vehicle', read_only=True)
    driver_detail = UserSerializer(source='driver', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = FleetTrip
        fields = [
            'id', 'trip_code', 'vehicle', 'vehicle_detail', 'driver',
            'driver_detail', 'dispatch_order_id', 'origin', 'destination',
            'total_gross_weight_kg', 'start_km', 'end_km', 'pod_signature_url',
            'pod_otp_verified', 'status', 'status_display', 'created_at'
        ]

class FuelLogSerializer(serializers.ModelSerializer):
    vehicle_detail = FleetVehicleSerializer(source='vehicle', read_only=True)
    driver_detail = UserSerializer(source='driver', read_only=True)

    class Meta:
        model = FuelLog
        fields = [
            'id', 'vehicle', 'vehicle_detail', 'driver', 'driver_detail',
            'date', 'fuel_liters', 'cost_amount', 'receipt_photo_url'
        ]
