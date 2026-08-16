import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';
import '../widgets/stat_metric_card.dart';

class AssetDashboardScreen extends StatefulWidget {
  const AssetDashboardScreen({super.key});

  @override
  State<AssetDashboardScreen> createState() => _AssetDashboardScreenState();
}

class _AssetDashboardScreenState extends State<AssetDashboardScreen> {
  Map<String, dynamic> _metrics = {
    'total_count': 0,
    'total_valuation': 0.0,
    'available_count': 0,
    'assigned_count': 0,
    'maintenance_count': 0,
    'damaged_count': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardMetrics();
  }

  Future<void> _fetchDashboardMetrics() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getAssetDashboard();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _metrics = response['data']['metrics'] ?? _metrics;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    final double totalValuation = (_metrics['total_valuation'] ?? 0.0).toDouble();
    final int totalCount = _metrics['total_count'] ?? 0;
    final int availableCount = _metrics['available_count'] ?? 0;
    final int assignedCount = _metrics['assigned_count'] ?? 0;
    final int maintenanceCount = _metrics['maintenance_count'] ?? 0;

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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                            tooltip: 'Refresh Metrics',
                            onPressed: _fetchDashboardMetrics,
                          ),
                          const SizedBox(width: 8),
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
                        children: [
                          StatMetricCard(
                            title: 'Total Capital Assets',
                            value: '₹${totalValuation.toStringAsFixed(2)}',
                            subtext: '$totalCount Registered Assets in DB',
                            icon: Icons.account_balance_wallet_rounded,
                            iconColor: AppColors.primaryCyan,
                            badgeText: '100% DB Live',
                          ),
                          StatMetricCard(
                            title: 'Available Equipment',
                            value: '$availableCount',
                            subtext: 'Ready for Assignment',
                            icon: Icons.check_circle_rounded,
                            iconColor: AppColors.emeraldGreen,
                            badgeText: 'Available 🟢',
                          ),
                          StatMetricCard(
                            title: 'Assigned to Staff/Drivers',
                            value: '$assignedCount',
                            subtext: 'In Active Deployment',
                            icon: Icons.person_pin_circle_rounded,
                            iconColor: AppColors.primaryCyan,
                            badgeText: 'Assigned 🔵',
                          ),
                          StatMetricCard(
                            title: 'Under Servicing / Maintenance',
                            value: '$maintenanceCount',
                            subtext: 'Active Maintenance Logs',
                            icon: Icons.build_circle_rounded,
                            iconColor: AppColors.amberWarning,
                            badgeText: 'Servicing 🟡',
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
