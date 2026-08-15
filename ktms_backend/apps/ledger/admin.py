# pyrefly: ignore [missing-import]
from django.contrib import admin
from ledger.models import CustomerLedger

admin.site.register(CustomerLedger)

