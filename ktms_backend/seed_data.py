import os
import sys
import django

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'apps'))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
django.setup()

from users.models import CustomUser, UserRole, WholesaleProfile, WholesaleStatus
from products.models import Category, Product
from pricing.models import WholesalePriceTier
from inventory.models import Warehouse, StockInventory
from assets.models import Asset, AssetCategory, AssetStatus
from fleet.models import FleetVehicle, VehicleType
import datetime

def seed():
    print("Seeding initial data for Krishna Trading ERP...")

    # 1. Super Admin Account
    admin_user, created = CustomUser.objects.get_or_create(
        username="admin@krishnatrading.com",
        defaults={
            "email": "admin@krishnatrading.com",
            "first_name": "Aryan",
            "last_name": "Parmar",
            "role": UserRole.SUPER_ADMIN,
            "mobile": "+919876548149",
            "dob": datetime.date(2004, 8, 15)
        }
    )
    if created:
        admin_user.set_password("Admin@123")
        admin_user.generate_admin_security_key("Parmar", "8149", 2004)
        admin_user.save()
        print(f"Created Super Admin: admin@krishnatrading.com (Security Key: {admin_user.admin_security_key})")

    # 2. General Manager Account
    mgr_user, created = CustomUser.objects.get_or_create(
        username="manager@krishnatrading.com",
        defaults={
            "email": "manager@krishnatrading.com",
            "first_name": "Suresh",
            "last_name": "Patel",
            "role": UserRole.GENERAL_MANAGER,
            "mobile": "+919876543210",
            "dob": datetime.date(1995, 5, 20)
        }
    )
    if created:
        mgr_user.set_password("Manager@123")
        mgr_user.generate_admin_security_key("Patel", "3210", 1995)
        mgr_user.save()
        print(f"Created Manager: manager@krishnatrading.com")

    # 3. Fleet Manager Account
    fleet_mgr, created = CustomUser.objects.get_or_create(
        username="fleet@krishnatrading.com",
        defaults={
            "email": "fleet@krishnatrading.com",
            "first_name": "Ramesh",
            "last_name": "Kumar",
            "role": UserRole.FLEET_MANAGER,
            "mobile": "+919876543211",
            "dob": datetime.date(1992, 10, 10)
        }
    )
    if created:
        fleet_mgr.set_password("Fleet@123")
        fleet_mgr.save()
        print("Created Fleet Manager: fleet@krishnatrading.com")

    # 4. Driver Account
    driver_user, created = CustomUser.objects.get_or_create(
        username="driver1@krishnatrading.com",
        defaults={
            "email": "driver1@krishnatrading.com",
            "first_name": "Rahul",
            "last_name": "Singh",
            "role": UserRole.DRIVER,
            "mobile": "+919876543212",
            "license_no": "GJ01-2021004589"
        }
    )
    if created:
        driver_user.set_password("Driver@123")
        driver_user.save()
        print("Created Driver: driver1@krishnatrading.com")

    # 5. Product Categories
    cat_wpp, _ = Category.objects.get_or_create(name="WPP Sacks & Kanta Bags", description="Heavy duty woven polypropylene bags")
    cat_plastic, _ = Category.objects.get_or_create(name="Plastic Packaging Bags", description="Heavy grade clear plastic export sacks")
    cat_box, _ = Category.objects.get_or_create(name="Corrugated Master Boxes", description="Heavy 5-ply export master cartons")

    # 6. Master Products with Unit Weights
    p1, _ = Product.objects.get_or_create(
        sku="KT-WPP-501",
        defaults={
            "name": "Heavy Jumbo Kanta WPP Bag (500 Pcs Bale)",
            "category": cat_wpp,
            "hsn_code": "3923",
            "primary_unit": "BALE",
            "secondary_unit": "PCS",
            "conversion_rate": 500,
            "unit_weight_kg": 65.00,
            "retail_price_per_unit": 650.00,
            "min_stock_alert": 5
        }
    )
    p2, _ = Product.objects.get_or_create(
        sku="KT-BOX-901",
        defaults={
            "name": "Export Heavy 5-Ply Master Carton Box",
            "category": cat_box,
            "hsn_code": "4819",
            "primary_unit": "CARTON",
            "secondary_unit": "PCS",
            "conversion_rate": 50,
            "unit_weight_kg": 12.50,
            "retail_price_per_unit": 180.00,
            "min_stock_alert": 10
        }
    )

    # Wholesale Price Tiers
    WholesalePriceTier.objects.get_or_create(product=p1, min_qty=1, max_qty=10, defaults={"tier_price_per_unit": 600.00})
    WholesalePriceTier.objects.get_or_create(product=p1, min_qty=11, max_qty=50, defaults={"tier_price_per_unit": 550.00})

    # 7. Warehouses & Initial Inventory
    wh1, _ = Warehouse.objects.get_or_create(code="GODOWN-A", name="Krishna Main Godown A", address="Industrial Zone, Plot 42")
    StockInventory.objects.get_or_create(product=p1, warehouse=wh1, defaults={"total_physical_pcs": 25000, "locked_pcs": 2500})
    StockInventory.objects.get_or_create(product=p2, warehouse=wh1, defaults={"total_physical_pcs": 5000, "locked_pcs": 200})

    # 8. Fleet Vehicles with Payload Capacities
    v_activa_asset, _ = Asset.objects.get_or_create(asset_code="AST-ACT-01", name="Activa Delivery Scooter #1", category=AssetCategory.VEHICLE, purchase_cost=85000)
    FleetVehicle.objects.get_or_create(asset=v_activa_asset, registration_no="GJ-01-AB-1234", vehicle_type=VehicleType.ACTIVA, payload_capacity_kg=50.00)

    v_hathi_asset, _ = Asset.objects.get_or_create(asset_code="AST-TAT-01", name="Chhota Hathi / Tata Ace", category=AssetCategory.VEHICLE, purchase_cost=450000)
    FleetVehicle.objects.get_or_create(asset=v_hathi_asset, registration_no="GJ-01-CD-5678", vehicle_type=VehicleType.CHHOTA_HATHI, payload_capacity_kg=500.00)

    v_tempo_asset, _ = Asset.objects.get_or_create(asset_code="AST-TMP-01", name="Heavy Delivery Tempo", category=AssetCategory.VEHICLE, purchase_cost=850000)
    FleetVehicle.objects.get_or_create(asset=v_tempo_asset, registration_no="GJ-01-EF-9012", vehicle_type=VehicleType.TEMPO, payload_capacity_kg=1000.00)

    v_truck_asset, _ = Asset.objects.get_or_create(asset_code="AST-TRK-01", name="10-Wheeler Heavy Export Truck", category=AssetCategory.VEHICLE, purchase_cost=2500000)
    FleetVehicle.objects.get_or_create(asset=v_truck_asset, registration_no="GJ-01-GH-3456", vehicle_type=VehicleType.TRUCK, payload_capacity_kg=5000.00)

    print("Data Seeding Completed Successfully!")

if __name__ == '__main__':
    seed()
