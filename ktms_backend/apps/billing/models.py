from django.db import models
from orders.models import Order

class InvoiceType(models.TextChoices):
    TAX_INVOICE = 'TAX_INVOICE', 'GST Tax Invoice'
    PROFORMA = 'PROFORMA', 'B2B Proforma Invoice'

class Invoice(models.Model):
    invoice_no = models.CharField(max_length=50, unique=True)
    order = models.OneToOneField(Order, on_delete=models.CASCADE, related_name='invoice')
    invoice_type = models.CharField(max_length=30, choices=InvoiceType.choices, default=InvoiceType.TAX_INVOICE)
    cgst_rate = models.DecimalField(max_digits=5, decimal_places=2, default=9.00)
    sgst_rate = models.DecimalField(max_digits=5, decimal_places=2, default=9.00)
    igst_rate = models.DecimalField(max_digits=5, decimal_places=2, default=18.00)
    cgst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    sgst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    igst_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    grand_total = models.DecimalField(max_digits=12, decimal_places=2)
    invoice_pdf_url = models.CharField(max_length=500, blank=True)
    is_paid = models.BooleanField(default=False)
    paid_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Invoice {self.invoice_no} (Order #{self.order.order_no})"
