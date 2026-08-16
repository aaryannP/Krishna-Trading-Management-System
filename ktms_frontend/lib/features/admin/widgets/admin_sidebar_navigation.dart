import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminSidebarNavigation extends StatelessWidget {
  final String currentRoute;

  const AdminSidebarNavigation({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.surfaceCard,
      child: Column(
        children: [
          // Brand Logo Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.surfaceCardBorder),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryCyan.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: AppColors.primaryCyan,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KRISHNA TRADING',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCyan,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'ERP Executive Suite',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                _buildNavHeader('MAIN ENTERPRISE'),
                _buildNavItem(context, 'Executive Dashboard', Icons.dashboard_rounded, '/admin/dashboard'),
                _buildNavItem(context, 'Admin Profile', Icons.admin_panel_settings_rounded, '/admin/profile'),
                
                const SizedBox(height: 16),
                _buildNavHeader('PERSONNEL & STAFF'),
                _buildNavItem(context, 'User Directory', Icons.people_alt_rounded, '/admin/users'),
                _buildNavItem(context, 'Add Person / Staff', Icons.person_add_alt_1_rounded, '/admin/users/add'),

                const SizedBox(height: 16),
                _buildNavHeader('EQUIPMENT ASSETS'),
                _buildNavItem(context, 'Asset Dashboard', Icons.assessment_rounded, '/admin/assets/dashboard'),
                _buildNavItem(context, 'Add Asset', Icons.add_box_rounded, '/admin/assets/add'),
                _buildNavItem(context, 'Asset Master List', Icons.list_alt_rounded, '/admin/assets/list'),
                _buildNavItem(context, 'Assign Asset', Icons.assignment_ind_rounded, '/admin/assets/assign'),
                _buildNavItem(context, 'Asset History', Icons.history_rounded, '/admin/assets/history'),
                _buildNavItem(context, 'Asset Maintenance', Icons.build_circle_rounded, '/admin/assets/maintenance'),
                _buildNavItem(context, 'Asset Categories', Icons.category_rounded, '/admin/assets/categories'),

                const SizedBox(height: 16),
                _buildNavHeader('FLEET & LOGISTICS'),
                _buildNavItem(context, 'Fleet Overview', Icons.local_shipping_rounded, '/admin/fleet/dashboard'),
                _buildNavItem(context, 'Vehicles Inventory', Icons.directions_car_rounded, '/admin/fleet/vehicles'),
                _buildNavItem(context, 'Add Vehicle', Icons.add_road_rounded, '/admin/fleet/vehicles/add'),
                _buildNavItem(context, 'Drivers Directory', Icons.badge_rounded, '/admin/fleet/drivers'),
                _buildNavItem(context, 'Driver Details Audit', Icons.person_pin_rounded, '/admin/fleet/drivers/details'),
                _buildNavItem(context, 'Trip Dispatch Tracker', Icons.alt_route_rounded, '/admin/fleet/trips'),
                _buildNavItem(context, 'Trip POD Inspection', Icons.fact_check_rounded, '/admin/fleet/trips/details'),
                _buildNavItem(context, 'Fuel Management Audit', Icons.local_gas_station_rounded, '/admin/fleet/fuel'),
                _buildNavItem(context, 'Vehicle Repair Logs', Icons.car_repair_rounded, '/admin/fleet/maintenance'),
                _buildNavItem(context, 'PUC & Insurance Alerts', Icons.description_rounded, '/admin/fleet/documents'),
                _buildNavItem(context, 'Dispatch Payload Matcher', Icons.scale_rounded, '/admin/fleet/dispatch'),

                const SizedBox(height: 16),
                _buildNavHeader('REPORTS & SECURITY'),
                _buildNavItem(context, 'Reports & Analytics', Icons.analytics_rounded, '/admin/reports/analytics'),
                _buildNavItem(context, 'System Security Settings', Icons.settings_suggest_rounded, '/admin/system/settings'),
              ],
            ),
          ),

          // Footer / Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.surfaceCardBorder),
              ),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: AppColors.coralRed.withOpacity(0.1),
              leading: const Icon(Icons.logout_rounded, color: AppColors.coralRed),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.coralRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textDisabled,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route) {
    final isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: isActive ? AppColors.primaryCyan.withOpacity(0.15) : Colors.transparent,
          leading: Icon(
            icon,
            size: 20,
            color: isActive ? AppColors.primaryCyan : AppColors.textSecondary,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppColors.primaryCyan : AppColors.textSecondary,
            ),
          ),
          trailing: isActive
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryCyan,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            if (!isActive) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
        ),
      ),
    );
  }
}
