import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Asset Master List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/list')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/list'),
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
                          Text('Equipment Asset Inventory List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Complete master ledger of all physical machinery, tools, and vehicles.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/assets/add'),
                        icon: const Icon(Icons.add, color: AppColors.background),
                        label: const Text('Add Asset', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
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
                          DataColumn(label: Text('ASSET CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ASSET NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('CATEGORY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ASSIGNEE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('COST', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                        ],
                        rows: [
                          _buildRow('AST-1001', 'Automatic WPP Bale Pressing Machine', 'Heavy Machinery', 'Factory Operator', '₹12,50,000', 'Operational 🟢', AppColors.emeraldGreen),
                          _buildRow('AST-1002', 'Digital 50-Ton Truck Weighbridge', 'Electronic Equipment', 'Weighmaster', '₹6,80,000', 'Maintenance 🟡', AppColors.amberWarning),
                          _buildRow('AST-1003', 'Honda Activa 6G (50kg Sample Cargo)', 'Logistics Vehicle', 'Driver (Vikram)', '₹88,000', 'Operational 🟢', AppColors.emeraldGreen),
                          _buildRow('AST-1004', 'Mahindra Supro Chhota Hathi (500kg)', 'Logistics Vehicle', 'Driver (Mahesh)', '₹6,40,000', 'Operational 🟢', AppColors.emeraldGreen),
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

  DataRow _buildRow(String code, String name, String category, String assignee, String cost, String status, Color color) {
    return DataRow(
      cells: [
        DataCell(Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(Text(name, style: const TextStyle(color: AppColors.textPrimary))),
        DataCell(Text(category, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(assignee, style: const TextStyle(color: AppColors.textSecondary))),
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
