import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetHistoryScreen extends StatelessWidget {
  const AssetHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Asset Handover History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/history')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/history'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Asset Allocation & Transfer History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Audit trail log of all asset handovers, returns, and reassignment events.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                          DataColumn(label: Text('DATE & TIME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ASSET CODE & NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('EVENT TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ASSIGNEE / DRIVER', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('REMARKS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                        ],
                        rows: [
                          _buildLogRow('15 Aug 2026, 10:30 AM', 'AST-1003 (Honda Activa 6G)', 'Handover Assigned', 'Vikram Singh (Driver)', 'Assigned for sample delivery route 01'),
                          _buildLogRow('14 Aug 2026, 04:15 PM', 'AST-1002 (50-Ton Weighbridge)', 'Maintenance Sent', 'Servicing Vendor (Apex Tech)', 'Calibration & sensor repair'),
                          _buildLogRow('10 Aug 2026, 09:00 AM', 'AST-1004 (Mahindra Supro)', 'Handover Assigned', 'Mahesh Kumar (Driver)', 'Assigned for B2B wholesale bales delivery'),
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

  DataRow _buildLogRow(String date, String asset, String event, String assignee, String remarks) {
    return DataRow(
      cells: [
        DataCell(Text(date, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(asset, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryCyan.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(event, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryCyan)),
          ),
        ),
        DataCell(Text(assignee, style: const TextStyle(color: AppColors.textPrimary))),
        DataCell(Text(remarks, style: const TextStyle(color: AppColors.textSecondary))),
      ],
    );
  }
}
