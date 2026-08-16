import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registration_screen.dart';
import 'features/auth/screens/ban_48hr_screen.dart';
import 'features/auth/screens/freeze_24hr_screen.dart';
import 'features/dashboard/screens/welcome_dashboard.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/admin_profile_screen.dart';
import 'features/admin/screens/user_management_screen.dart';
import 'features/admin/screens/add_person_screen.dart';
import 'features/admin/screens/asset_dashboard_screen.dart';
import 'features/admin/screens/add_asset_screen.dart';
import 'features/admin/screens/asset_list_screen.dart';
import 'features/admin/screens/assign_asset_screen.dart';
import 'features/admin/screens/asset_history_screen.dart';
import 'features/admin/screens/asset_maintenance_screen.dart';
import 'features/admin/screens/asset_categories_screen.dart';
import 'features/admin/screens/fleet_dashboard_screen.dart';
import 'features/admin/screens/vehicles_list_screen.dart';
import 'features/admin/screens/add_vehicle_screen.dart';
import 'features/admin/screens/drivers_list_screen.dart';
import 'features/admin/screens/driver_details_screen.dart';
import 'features/admin/screens/trip_management_screen.dart';
import 'features/admin/screens/trip_details_screen.dart';
import 'features/admin/screens/fuel_management_screen.dart';
import 'features/admin/screens/vehicle_maintenance_screen.dart';
import 'features/admin/screens/vehicle_documents_screen.dart';
import 'features/admin/screens/dispatch_management_screen.dart';
import 'features/admin/screens/reports_analytics_screen.dart';
import 'features/admin/screens/system_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KtmsApp());
}

class KtmsApp extends StatelessWidget {
  const KtmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Krishna Trading ERP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkMode,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/ban-48hr': (context) => const Ban48HrScreen(),
          '/freeze-24hr': (context) => const Freeze24HrScreen(),
          '/welcome': (context) => const WelcomeDashboard(),

          // Super Admin ERP Suite - Part 1 (Pages 1 to 12)
          '/admin/dashboard': (context) => const AdminDashboardScreen(),
          '/admin/profile': (context) => const AdminProfileScreen(),
          '/admin/users': (context) => const UserManagementScreen(),
          '/admin/users/add': (context) => const AddPersonScreen(),
          '/admin/assets/dashboard': (context) => const AssetDashboardScreen(),
          '/admin/assets/add': (context) => const AddAssetScreen(),
          '/admin/assets/list': (context) => const AssetListScreen(),
          '/admin/assets/assign': (context) => const AssignAssetScreen(),
          '/admin/assets/history': (context) => const AssetHistoryScreen(),
          '/admin/assets/maintenance': (context) => const AssetMaintenanceScreen(),
          '/admin/assets/categories': (context) => const AssetCategoriesScreen(),
          '/admin/fleet/dashboard': (context) => const FleetDashboardScreen(),

          // Super Admin ERP Suite - Part 2 (Pages 13 to 24)
          '/admin/fleet/vehicles': (context) => const VehiclesListScreen(),
          '/admin/fleet/vehicles/add': (context) => const AddVehicleScreen(),
          '/admin/fleet/drivers': (context) => const DriversListScreen(),
          '/admin/fleet/drivers/details': (context) => const DriverDetailsScreen(),
          '/admin/fleet/trips': (context) => const TripManagementScreen(),
          '/admin/fleet/trips/details': (context) => const TripDetailsScreen(),
          '/admin/fleet/fuel': (context) => const FuelManagementScreen(),
          '/admin/fleet/maintenance': (context) => const VehicleMaintenanceScreen(),
          '/admin/fleet/documents': (context) => const VehicleDocumentsScreen(),
          '/admin/fleet/dispatch': (context) => const DispatchManagementScreen(),
          '/admin/reports/analytics': (context) => const ReportsAnalyticsScreen(),
          '/admin/system/settings': (context) => const SystemSettingsScreen(),
        },
      ),
    );
  }
}
