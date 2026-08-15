import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetCategoriesScreen extends StatelessWidget {
  const AssetCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Asset Categories & Depreciation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/categories')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/categories'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Asset Categories & Depreciation Rules', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Configure asset classes and annual depreciation percentage rates.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                          DataColumn(label: Text('CATEGORY NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('TOTAL ASSETS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ANNUAL DEPRECIATION %', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ESTIMATED VALUATION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                        ],
                        rows: [
                          _buildCatRow('Heavy Machinery', '12 Items', '15% WDV', '₹18,50,000'),
                          _buildCatRow('Logistics Vehicles', '10 Vehicles', '20% WDV', '₹11,20,000'),
                          _buildCatRow('Electronic Equipment', '16 Items', '40% SLM', '₹3,60,000'),
                          _buildCatRow('Godown Tooling', '10 Items', '10% SLM', '₹1,50,000'),
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

  DataRow _buildCatRow(String name, String count, String dep, String val) {
    return DataRow(
      cells: [
        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        DataCell(Text(count, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(dep, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.amberWarning))),
        DataCell(Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
      ],
    );
  }
}
