from django.db import models
from products.models import Product
from users.models import CustomUser

class Warehouse(models.Model):
    code = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=100)
    address = models.TextField(blank=True)

    def __str__(self):
        return f"{self.name} ({self.code})"

class StockInward(models.Model):
    supplier_name = models.CharField(max_length=255)
    inward_date = models.DateField()
    hsn_code = models.CharField(max_length=20, default='3923')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    bales_received = models.IntegerField()
    total_pcs_calculated = models.IntegerField()
    total_weight_kg = models.DecimalField(max_digits=10, decimal_places=2)

    def save(self, *args, **kwargs):
        if not self.total_pcs_calculated:
            self.total_pcs_calculated = self.bales_received * self.product.conversion_rate
        if not self.total_weight_kg:
            self.total_weight_kg = float(self.bales_received) * float(self.product.unit_weight_kg)
        super().save(*args, **kwargs)

class StockInventory(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='inventory')
    warehouse = models.ForeignKey(Warehouse, on_delete=models.CASCADE)
    total_physical_pcs = models.IntegerField(default=0)
    locked_pcs = models.IntegerField(default=0)

    @property
    def net_available_pcs(self):
        return max(0, self.total_physical_pcs - self.locked_pcs)

    def __str__(self):
        return f"{self.product.name} @ {self.warehouse.name}: Available {self.net_available_pcs} Pcs"

class DamageLog(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    qty_damaged = models.IntegerField()
    reason = models.CharField(max_length=255)
    photo_url = models.CharField(max_length=500, blank=True)
    reported_by = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
