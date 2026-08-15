# Krishna Trading Management System (KTMS) / Krishna Trading ERP

## Executive Summary & System Scope
**Krishna Trading** is a commercial B2B bulk manufacturer, supplier, and exporter of packaging solutions (WPP Sacks, Kanta Bags, Plastic Sacks, Master Cartons).

**KTMS / Krishna Trading ERP** is a production-grade multi-tenant enterprise system comprising:
1. **Django REST API Backend (Python & PostgreSQL)** with fine-grained Role-Based Access Control (RBAC).
2. **Admin Web/Mobile ERP Suite** for Super Admin, Admin, and Managers.
3. **Customer Mobile Application (Flutter)** for Retail B2C & Wholesale B2B clients.

---

## 🔒 Custom Enterprise Authentication & Security Engine

### 1. Registration Flow & Dynamic Admin Passkey
- **Form Fields:**
  - Row 1: Role Dropdown (Admin, Manager, Wholesale Customer, Retail Customer).
  - Row 2: First Name & Last Name.
  - Row 3: Email.
  - Row 4: Date of Birth (DOB) & Mobile Number.
  - Row 5: Password.
  - Row 6: Confirm Password.
  - Row 7 (Dynamic Field): **Admin Passkey** (Appears ONLY when Role == 'Admin'. Verified against Master Passkey in Django `settings.py`).

### 2. Registration OTP Verification & 48-Hour Suspicious Ban
- **OTP Delivery:** 6-digit OTP sent to registered Email with a 60-second Resend Timer.
- **3 Failed OTP Attempts (48-Hour Ban):**
  - Registration halted; user details added to `SuspiciousActivity` DB table with a 48-hour TTL.
  - Automatic Email Alert dispatched: *"Suspicious Activity Detected! Registration blocked for 48 Hours"* with countdown timer (`47:59:59` ➔ `00:00:00`).
  - After 48 hours, the blacklist entry auto-expires.
- **Successful OTP:** 🟢 Green Toast Popup *"User Registered Successfully!"* ➔ Redirect to Login.

### 3. Dynamic Admin Security Key & Login Security
- **Form Fields:** Email + Password.
- **Dynamic Admin Security Key (Login Page):**
  - When Email is typed, backend/frontend checks if `user.role == ADMIN`.
  - If Admin, Dynamic field **`Admin Security Key`** renders on Login.
- **Admin Security Key Formula:**
  $$\text{Key} = \text{LASTNAME\_4\_UPPER} + \text{MOBILE\_LAST\_4} + \text{BIRTH\_YEAR}$$
  *(e.g., Aryan Parmar, Mobile: ******8149, DOB Year: 2004 ➔ `PARM81492004`)*
- **3 Failed Login Attempts (24-Hour Account Freeze):**
  - Account status set to Frozen for 24 Hours.
  - Automatic Email Alert: *"Suspicious Activity Detected! Account Frozen for 24 Hours"* with countdown timer (`23:59:59` ➔ `00:00:00`).
- **Successful Login:** 🟢 Green Toast Popup *"Login Successfully!"* ➔ Redirect to Dashboard.
- **Failed Credentials:** 🔴 Red Toast Popup *"Wrong Credentials!"*.

### 4. Forgot Password & Password Reset Flow
- **Step 1:** Email input field ➔ "Send OTP" ➔ 60s Resend Timer.
- *Security:* 3 Failed OTP attempts ➔ Account Frozen for 24 Hours + Email Alert.
- **Step 2 (Reset Password Screen):**
  - Field 1: Email (Disabled / Read-Only).
  - Field 2: New Password.
  - Field 3: Confirm New Password.
- **On Submit:** 🟢 Green Toast Popup *"Password Reset Successfully!"* ➔ Redirect to Login Page.

---

## 🎨 Complete 24 Admin Panel Screens Blueprint

```
1. Dashboard (Landing Page)           13. Vehicles List
2. Profile                            14. Add Vehicle
3. User Management (Person List)      15. Drivers List
4. Add Person                         16. Driver Details
5. Asset Management - Dashboard       17. Trip Management
6. Add Asset                          18. Trip Details (with Map Route)
7. Asset List                         19. Fuel Management
8. Assign Asset                       20. Vehicle Maintenance
9. Asset History                      21. Documents & Insurance
10. Asset Maintenance                 22. Dispatch Management
11. Asset Categories                  23. Reports & Analytics
12. Fleet Management - Dashboard      24. Admin Panel (System Control)
```

---

## 📋 Outstanding Planning Agenda (To Be Discussed Next Session)

1. 🟡 **Manager Dashboard & Granular Permissions Flow**
2. 🔵 **Customer Side (Flutter Mobile App):**
   - **Retail B2C Flow:** Amazon/Flipkart style catalog, cart, instant checkout.
   - **Wholesale B2B Flow:** Tiered bulk pricing, Admin approval workflow, custom contract rates, Account Ledger (Khaata).
