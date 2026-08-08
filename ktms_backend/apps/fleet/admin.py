from django.contrib import admin
from fleet.models import FleetVehicle, FleetTrip, FuelLog

admin.site.register(FleetVehicle)
admin.site.register(FleetTrip)
admin.site.register(FuelLog)

