# pyrefly: ignore [missing-import]
from django.db import models
from users.models import CustomUser

class AssetCategory(models.TextChoices):
    VEHICLE = 'VEHICLE', 'Fleet Vehicle'
    MACHINE = 'MACHINE', 'Factory & Stitching Machine'
    IT = 'IT', 'IT / Computer Equipment'
    WAREHOUSE = 'WAREHOUSE', 'Warehouse & Weighing Scale'

class AssetStatus(models.TextChoices):
    AVAILABLE = 'AVAILABLE', 'Available'
    ASSIGNED = 'ASSIGNED', 'Assigned to Person'
    MAINTENANCE = 'MAINTENANCE', 'Under Maintenance'
    DAMAGED = 'DAMAGED', 'Damaged / Retired'

class Asset(models.Model):
    asset_code = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=200)
    category = models.CharField(max_length=30, choices=AssetCategory.choices)
    model_no = models.CharField(max_length=100, blank=True)
    serial_no = models.CharField(max_length=100, blank=True)
    purchase_date = models.DateField(null=True, blank=True)
    purchase_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    status = models.CharField(max_length=30, choices=AssetStatus.choices, default=AssetStatus.AVAILABLE)

    def __str__(self):
        return f"{self.name} [{self.asset_code}] - {self.status}"

class AssetAssignment(models.Model):
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='assignments')
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='assigned_assets')
    assigned_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='made_assignments')
    assigned_date = models.DateTimeField(auto_now_add=True)
    return_date = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.asset.name} ➔ {self.user.get_full_name() or self.user.username}"

class AssetMaintenance(models.Model):
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='maintenance_logs')
    service_type = models.CharField(max_length=100)
    service_date = models.DateField()
    cost = models.DecimalField(max_digits=10, decimal_places=2)
    vendor_name = models.CharField(max_length=200, blank=True)
    status = models.CharField(max_length=50, default='Completed')

    def __str__(self):
        return f"{self.asset.name} Servicing on {self.service_date}"
