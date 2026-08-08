# 🏢 Krishna Trading Management System (KTMS) - Backend REST APIs

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/)
[![Django](https://img.shields.io/badge/Django-5.2-green.svg)](https://www.djangoproject.com/)
[![Django REST Framework](https://img.shields.io/badge/DRF-3.18-red.svg)](https://www.django-rest-framework.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📌 Executive Summary
**Krishna Trading** is a commercial B2B bulk manufacturer, supplier, and exporter of heavy industrial packaging materials (WPP Sacks, Kanta Bags, Plastic Packaging Bags, Corrugated Master Boxes).

**KTMS / Krishna Trading ERP** is a decoupled enterprise system built with:
- **Headless Django REST Framework (DRF) Backend** with fine-grained Role-Based Access Control (RBAC).
- **21 PostgreSQL Master Database Schemas** covering Auth, Products, Pricing Tiers, Inventory Warehouses, Assets, Fleet Allocation, Orders, GST Invoices, and B2B Financial Ledgers.
- **Flutter Multi-Platform (Web & Mobile Apps)** for Super Admin, General Manager, Fleet Manager, Shop Staff, Drivers, Retail B2C, and Wholesale B2B Customers.

---

## 🔒 Enterprise Security & Multi-Role Rules
1. **Public Signup Role Isolation:** Public registration ONLY permits `RETAIL_CUSTOMER` and `WHOLESALE_CUSTOMER`. Internal staff (`SUPER_ADMIN`, `GENERAL_MANAGER`, `FLEET_MANAGER`, `STAFF`, `DRIVER`) can ONLY be created internally via `Add Person` Admin API.
2. **48-Hour Registration Ban:** 3 failed OTP attempts during signup trigger a `SuspiciousActivity` 48-hour block with live remaining seconds calculation (`172,800` seconds).
3. **Dynamic Admin Security Key:** Generated automatically during Admin registration via `LASTNAME_4_UPPER` + `MOBILE_LAST_4` + `BIRTH_YEAR` (e.g., `PARM81492004`).
4. **24-Hour Account Freeze:** 3 failed login attempts or wrong Admin Security Key entries freeze the account for 24 hours.
5. **Smart Fleet Payload Matcher:** Automatic order gross weight calculation ($\sum \text{Qty} \times \text{Unit Weight}$) matching vehicles (Activa $\le50$kg, Chhota Hathi $\le500$kg, Tempo $\le1000$kg, Heavy Truck $>1000$kg).

---

## ⚡ REST API Endpoint Modules (`/api/v1/`)

### 1. Authentication & Security
- `POST /api/v1/auth/register/` (Public Signup)
- `POST /api/v1/auth/verify-otp/` (Verify 6-digit OTP - 48-hr Ban Engine)
- `POST /api/v1/auth/login/` (Login with Dynamic Admin Security Key check)
- `GET /api/v1/users/` (List all users & role breakdown)
- `POST /api/v1/users/add-person/` (Create internal staff/driver)

### 2. Products, Pricing & Inventory
- `GET /api/v1/products/` & `POST /api/v1/products/` (Catalog & Unit Weight Mappings)
- `GET /api/v1/inventory/stock/` (Real-time Physical vs Locked Stock)
- `POST /api/v1/inventory/inward/` (Stock Inwarding from Mill)

### 3. Fleet & Logistics
- `GET /api/v1/fleet/vehicles/` (Vehicle Payload Capacities)
- `POST /api/v1/fleet/trips/` (Smart Freight Vehicle Recommendation)

---

## 🚀 Quick Setup & Installation

```bash
# 1. Clone repository
git clone https://github.com/aaryannP/Krishna-Trading-Management-System.git
cd Krishna-Trading-Management-System/ktms_backend

# 2. Install dependencies
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers pillow requests

# 3. Run Migrations & Seed Data
python manage.py migrate
python seed_data.py

# 4. Start Development Server
python manage.py runserver 0.0.0.0:8000
```

---

## 📄 License
Distributed under the **MIT License**. See `LICENSE` for more information.
