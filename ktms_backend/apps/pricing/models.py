from django.db import models
from products.models import Product
from users.models import CustomUser, WholesaleProfile

class WholesalePriceTier(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='price_tiers')
    min_qty = models.IntegerField(default=1)
    max_qty = models.IntegerField(default=50)
    tier_price_per_unit = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.product.name} ({self.min_qty}-{self.max_qty} Bales @ ₹{self.tier_price_per_unit})"

class ContractPricing(models.Model):
    wholesale_customer = models.ForeignKey(WholesaleProfile, on_delete=models.CASCADE, related_name='contract_prices')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    custom_negotiated_price = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"{self.wholesale_customer.company_name} - {self.product.name} @ ₹{self.custom_negotiated_price}"
