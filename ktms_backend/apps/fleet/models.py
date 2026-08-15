# pyrefly: ignore [missing-import]
from django.db import models
from assets.models import Asset
from users.models import CustomUser

class VehicleType(models.TextChoices):
    ACTIVA = 'ACTIVA', 'Activa / Scooter (Up to 50 Kg)'
    CHHOTA_HATHI = 'CHHOTA_HATHI', 'Chhota Hathi / Tata Ace (Up to 500 Kg)'
    TEMPO = 'TEMPO', 'Heavy Tempo (Up to 1,000 Kg / 1 Ton)'
    TRUCK = 'TRUCK', 'Heavy Export Truck (1 Ton+)'

class FleetVehicle(models.Model):
    asset = models.OneToOneField(Asset, on_delete=models.CASCADE, related_name='fleet_vehicle')
    registration_no = models.CharField(max_length=30, unique=True)
    vehicle_type = models.CharField(max_length=30, choices=VehicleType.choices)
    payload_capacity_kg = models.DecimalField(max_digits=8, decimal_places=2, default=500.00)
    puc_expiry = models.DateField(null=True, blank=True)
    insurance_expiry = models.DateField(null=True, blank=True)
    fitness_expiry = models.DateField(null=True, blank=True)

    @classmethod
    def suggest_vehicle_for_weight(cls, weight_kg):
        if weight_kg <= 50:
            target_types = [VehicleType.ACTIVA, VehicleType.CHHOTA_HATHI]
        elif weight_kg <= 500:
            target_types = [VehicleType.CHHOTA_HATHI, VehicleType.TEMPO]
        elif weight_kg <= 1000:
            target_types = [VehicleType.TEMPO, VehicleType.TRUCK]
        else:
            target_types = [VehicleType.TRUCK]
            
        return cls.objects.filter(vehicle_type__in=target_types)

    def __str__(self):
        return f"{self.registration_no} [{self.get_vehicle_type_display()}]"

class TripStatus(models.TextChoices):
    DISPATCHED = 'DISPATCHED', 'Dispatched'
    IN_TRANSIT = 'IN_TRANSIT', 'In Transit'
    DELIVERED = 'DELIVERED', 'Delivered (POD Signed)'

class FleetTrip(models.Model):
    trip_code = models.CharField(max_length=50, unique=True)
    vehicle = models.ForeignKey(FleetVehicle, on_delete=models.CASCADE, related_name='trips')
    driver = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='driver_trips')
    dispatch_order_id = models.CharField(max_length=100, blank=True)
    origin = models.CharField(max_length=255, default='Krishna Trading Warehouse')
    destination = models.CharField(max_length=255)
    total_gross_weight_kg = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    start_km = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    end_km = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    pod_signature_url = models.CharField(max_length=500, blank=True)
    pod_otp_verified = models.BooleanField(default=False)
    status = models.CharField(max_length=30, choices=TripStatus.choices, default=TripStatus.DISPATCHED)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Trip {self.trip_code} - {self.vehicle.registration_no} ({self.status})"

class FuelLog(models.Model):
    vehicle = models.ForeignKey(FleetVehicle, on_delete=models.CASCADE, related_name='fuel_logs')
    driver = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    date = models.DateField()
    fuel_liters = models.DecimalField(max_digits=8, decimal_places=2)
    cost_amount = models.DecimalField(max_digits=10, decimal_places=2)
    receipt_photo_url = models.CharField(max_length=500, blank=True)

    def __str__(self):
        return f"{self.vehicle.registration_no}: {self.fuel_liters}L @ ₹{self.cost_amount}"
