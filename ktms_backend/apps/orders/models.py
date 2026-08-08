from django.db import models
from users.models import CustomUser
from products.models import Product

class OrderType(models.TextChoices):
    RETAIL = 'RETAIL', 'Retail B2C'
    WHOLESALE = 'WHOLESALE', 'Wholesale B2B'

class OrderStatus(models.TextChoices):
    PENDING = 'PENDING', 'Pending Approval'
    STOCK_LOCKED = 'STOCK_LOCKED', 'Stock Locked / Approved'
    PACKING = 'PACKING', 'In Packing'
    DISPATCHED = 'DISPATCHED', 'Dispatched on Vehicle'
    DELIVERED = 'DELIVERED', 'Delivered'
    CANCELLED = 'CANCELLED', 'Cancelled'

class PaymentMethod(models.TextChoices):
    UPI = 'UPI', 'UPI (GPay / PhonePe / Paytm)'
    CREDIT_KHAATA = 'CREDIT_KHAATA', 'B2B 15/30 Day Credit Khaata'
    COD = 'COD', 'Cash On Delivery'
    NETBANKING = 'NETBANKING', 'Net Banking / Bank Transfer'

class Order(models.Model):
    order_no = models.CharField(max_length=50, unique=True)
    customer = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='orders')
    order_type = models.CharField(max_length=20, choices=OrderType.choices, default=OrderType.RETAIL)
    status = models.CharField(max_length=30, choices=OrderStatus.choices, default=OrderStatus.PENDING)
    payment_method = models.CharField(max_length=30, choices=PaymentMethod.choices, default=PaymentMethod.UPI)
    total_gross_weight_kg = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    subtotal = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    cgst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    sgst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    igst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    grand_total = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    delivery_address = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Order #{self.order_no} - {self.customer.username} ({self.status})"

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    qty_primary_bales = models.IntegerField(default=1)
    qty_secondary_pcs = models.IntegerField(default=500)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_price = models.DecimalField(max_digits=12, decimal_places=2)

    def save(self, *args, **kwargs):
        if not self.total_price:
            self.total_price = float(self.qty_primary_bales) * float(self.unit_price)
        super().save(*args, **kwargs)
