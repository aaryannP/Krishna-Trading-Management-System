from django.db import models
from users.models import CustomUser, WholesaleProfile
from billing.models import Invoice

class CustomerLedger(models.Model):
    customer = models.ForeignKey(WholesaleProfile, on_delete=models.CASCADE, related_name='ledger_entries')
    transaction_date = models.DateTimeField(auto_now_add=True)
    invoice = models.ForeignKey(Invoice, on_delete=models.SET_NULL, null=True, blank=True)
    reference_no = models.CharField(max_length=100) # Invoice No or Payment Receipt No
    notes = models.CharField(max_length=255, blank=True)
    debit_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0.00, help_text="Bill Amount Added")
    credit_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0.00, help_text="Payment Received")
    running_balance = models.DecimalField(max_digits=12, decimal_places=2, default=0.00, help_text="Outstanding Balance")

    def __str__(self):
        return f"{self.customer.company_name}: Debit ₹{self.debit_amount} | Credit ₹{self.credit_amount} (Balance: ₹{self.running_balance})"
