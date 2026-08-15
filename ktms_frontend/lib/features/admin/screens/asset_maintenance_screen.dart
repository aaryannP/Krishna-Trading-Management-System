import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetMaintenanceScreen extends StatelessWidget {
  const AssetMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Asset Maintenance & Repair', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/maintenance')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/maintenance'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Asset Repair & Servicing Requests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Track maintenance tickets, repair costs, and vendor servicing status.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.background),
                        columns: const [
                          DataColumn(label: Text('TICKET ID', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ASSET', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ISSUE DESCRIPTION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ESTIMATED COST', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('SERVICING STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                        ],
                        rows: [
                          _buildMaintRow('TKT-901', 'AST-1002 (50-Ton Weighbridge)', 'Sensor calibration & display panel flicker', '₹15,000', 'In Progress 🟡', AppColors.amberWarning),
                          _buildMaintRow('TKT-900', 'AST-1001 (Bale Press Machine)', 'Hydraulic oil leakage & seal replacement', '₹28,000', 'Completed 🟢', AppColors.emeraldGreen),
                        ],
                      ),
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

  DataRow _buildMaintRow(String id, String asset, String issue, String cost, String status, Color color) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(Text(asset, style: const TextStyle(color: AppColors.textPrimary))),
        DataCell(Text(issue, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(cost, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
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
