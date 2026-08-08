from django.contrib import admin
from users.models import CustomUser, WholesaleProfile, SuspiciousActivity

admin.site.register(CustomUser)
admin.site.register(WholesaleProfile)
admin.site.register(SuspiciousActivity)

