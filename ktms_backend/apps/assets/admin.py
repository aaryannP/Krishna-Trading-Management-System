from django.contrib import admin
from assets.models import Asset, AssetAssignment, AssetMaintenance

admin.site.register(Asset)
admin.site.register(AssetAssignment)
admin.site.register(AssetMaintenance)

