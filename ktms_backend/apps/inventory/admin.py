# pyrefly: ignore [missing-import]
from django.contrib import admin
from inventory.models import Warehouse, StockInventory, StockInward, DamageLog

admin.site.register(Warehouse)
admin.site.register(StockInventory)
admin.site.register(StockInward)
admin.site.register(DamageLog)

