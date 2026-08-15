# pyrefly: ignore [missing-import]
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=50, blank=True)

    def __str__(self):
        return self.name

class Product(models.Model):
    class PrimaryUnit(models.TextChoices):
        BALE = 'BALE', 'Bale / Master Bundle'
        CARTON = 'CARTON', 'Corrugated Master Carton'

    class SecondaryUnit(models.TextChoices):
        PCS = 'PCS', 'Pieces / Bags'
        KG = 'KG', 'Kilograms'

    sku = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=200)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    hsn_code = models.CharField(max_length=20, default='3923')
    primary_unit = models.CharField(max_length=20, choices=PrimaryUnit.choices, default=PrimaryUnit.BALE)
    secondary_unit = models.CharField(max_length=20, choices=SecondaryUnit.choices, default=SecondaryUnit.PCS)
    conversion_rate = models.IntegerField(default=500, help_text="e.g. 1 Bale = 500 Pieces")
    unit_weight_kg = models.DecimalField(max_digits=8, decimal_places=2, default=65.00, help_text="Weight of 1 Primary Unit in Kg")
    retail_price_per_unit = models.DecimalField(max_digits=10, decimal_places=2)
    min_stock_alert = models.IntegerField(default=5)
    image_url = models.CharField(max_length=500, blank=True)

    def __str__(self):
        return f"{self.name} ({self.sku})"
