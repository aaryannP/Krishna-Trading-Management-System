import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';
import '../widgets/stat_metric_card.dart';

class AssetDashboardScreen extends StatelessWidget {
  const AssetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Asset Management Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/dashboard')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/dashboard'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Equipment Asset Management Overview',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Track company machinery, vehicles, weighbridges, and electronic assets.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCyan,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/assets/add'),
                        icon: const Icon(Icons.add_box_rounded, color: AppColors.background, size: 18),
                        label: const Text('Register New Asset', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 4 Stat Cards
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
                            title: 'Total Capital Assets',
                            value: '₹34,80,000',
                            subtext: '48 Registered Machinery & Assets',
                            icon: Icons.account_balance_wallet_rounded,
                            iconColor: AppColors.primaryCyan,
                            badgeText: '48 Total',
                          ),
                          StatMetricCard(
                            title: 'Operational Assets',
                            value: '43 Active',
                            subtext: 'Assigned to Factory & Logistics',
                            icon: Icons.check_circle_rounded,
                            iconColor: AppColors.emeraldGreen,
                            badgeText: '90% Active',
                          ),
                          StatMetricCard(
                            title: 'Under Maintenance',
                            value: '3 Items',
                            subtext: '1 Weighbridge, 2 Hydraulic Lifts',
                            icon: Icons.build_rounded,
                            iconColor: AppColors.amberWarning,
                            badgeText: 'Servicing',
                            isPositiveBadge: false,
                          ),
                          StatMetricCard(
                            title: 'Unassigned Inventory',
                            value: '2 Items',
                            subtext: 'In Spare Storage Godown A',
                            icon: Icons.inventory_2_rounded,
                            iconColor: Colors.purpleAccent,
                            badgeText: 'Spare',
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Asset Quick Table
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'High-Value Asset Master Summary',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/admin/assets/list'),
                              child: const Text('View Full List →', style: TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(AppColors.background),
                            columns: const [
                              DataColumn(label: Text('ASSET CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('ASSET NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('CATEGORY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('ASSIGNEE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('PURCHASE COST', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                              DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                            ],
                            rows: [
                              _buildAssetRow('AST-1001', 'Automatic WPP Bale Pressing Machine', 'Heavy Machinery', 'Factory Operator (Ramesh)', '₹12,50,000', 'Operational 🟢', AppColors.emeraldGreen),
                              _buildAssetRow('AST-1002', 'Digital 50-Ton Truck Weighbridge', 'Electronic Equipment', 'Weighmaster (Suresh)', '₹6,80,000', 'Under Maintenance 🟡', AppColors.amberWarning),
                              _buildAssetRow('AST-1003', 'Honda Activa 6G (50kg Sample Cargo)', 'Logistics Vehicle', 'Delivery Driver (Vikram)', '₹88,000', 'Operational 🟢', AppColors.emeraldGreen),
                              _buildAssetRow('AST-1004', 'Mahindra Supro Chhota Hathi (500kg)', 'Logistics Vehicle', 'Driver (Mahesh)', '₹6,40,000', 'Operational 🟢', AppColors.emeraldGreen),
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

  DataRow _buildAssetRow(String code, String name, String category, String assignee, String cost, String status, Color color) {
    return DataRow(
      cells: [
        DataCell(Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        DataCell(Text(category, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(assignee, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(cost, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
      ],
    );
  }
}
