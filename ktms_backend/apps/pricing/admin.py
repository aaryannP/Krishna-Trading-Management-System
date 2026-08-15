# pyrefly: ignore [missing-import]
from django.contrib import admin
from pricing.models import WholesalePriceTier, ContractPricing

admin.site.register(WholesalePriceTier)
admin.site.register(ContractPricing)

