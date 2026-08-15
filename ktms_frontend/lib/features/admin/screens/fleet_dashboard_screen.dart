import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';
import '../widgets/stat_metric_card.dart';

class FleetDashboardScreen extends StatelessWidget {
  const FleetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Fleet Logistics Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/dashboard')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/dashboard'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fleet Logistics & Dispatch Operations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Vehicle payload capacity matcher, live driver trips, and fuel management.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 24),

                  // Fleet Stat Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int count = width < 650 ? 1 : (width < 1000 ? 2 : 4);
                      return GridView.count(
                        crossAxisCount: count,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: width < 650 ? 2.2 : 1.4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          StatMetricCard(
                            title: 'Active Fleet Vehicles',
                            value: '8 Vehicles',
                            subtext: 'Activa (2), Supro (3), Tempo (2), Truck (1)',
                            icon: Icons.local_shipping_rounded,
                            iconColor: AppColors.primaryCyan,
                            badgeText: '8 Active',
                          ),
                          StatMetricCard(
                            title: 'Trips In Transit Today',
                            value: '6 Dispatches',
                            subtext: '4 Wholesale Bales + 2 Retail Parcels',
                            icon: Icons.alt_route_rounded,
                            iconColor: AppColors.emeraldGreen,
                            badgeText: 'On Route',
                          ),
                          StatMetricCard(
                            title: 'Monthly Fuel Spend',
                            value: '₹84,500',
                            subtext: '842 Litres Diesel & Petrol',
                            icon: Icons.local_gas_station_rounded,
                            iconColor: AppColors.amberWarning,
                            badgeText: 'Logs Clear',
                          ),
                          StatMetricCard(
                            title: 'Active Drivers',
                            value: '8 Drivers',
                            subtext: 'POD Digital Signature Enabled',
                            icon: Icons.badge_rounded,
                            iconColor: Colors.purpleAccent,
                            badgeText: '100% Ready',
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Fleet Vehicles Capacity Table
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vehicle Capacity Master & Payload Matcher',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(AppColors.background),
                            columns: const [
                              DataColumn(label: Text('VEHICLE REG NO', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('MODEL & TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('MAX PAYLOAD CAPACITY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('ASSIGNED DRIVER', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('TRIP STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                            ],
                            rows: [
                              _buildFleetRow('GJ-01-AB-1001', 'Honda Activa 6G 🛵', '50 Kg Max (Sample Parcels)', 'Vikram Singh', 'In Transit (ORD-8819) 🚚', AppColors.primaryCyan),
                              _buildFleetRow('GJ-01-XY-2002', 'Mahindra Supro 🛺', '500 Kg Max (Medium Cartons)', 'Mahesh Kumar', 'Loading (ORD-8820) 🟡', AppColors.amberWarning),
                              _buildFleetRow('GJ-01-TR-3003', 'Eicher Pro Tempo 🚛', '1,000 Kg Max (1 Ton Cartons/Bales)', 'Rajesh Sharma', 'In Transit (ORD-8821) 🚚', AppColors.emeraldGreen),
                              _buildFleetRow('GJ-01-HV-4004', 'Tata Heavy Truck 🚚', '1,000+ Kg Bulk (1 Ton+ Export Bales)', 'Sanjay Patel', 'In Transit (ORD-8818) 🚚', AppColors.emeraldGreen),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildFleetRow(String reg, String model, String cap, String driver, String status, Color color) {
    return DataRow(
      cells: [
        DataCell(Text(reg, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(Text(model, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        DataCell(Text(cap, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.amberWarning))),
        DataCell(Text(driver, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
      ],
    );
  }
}
