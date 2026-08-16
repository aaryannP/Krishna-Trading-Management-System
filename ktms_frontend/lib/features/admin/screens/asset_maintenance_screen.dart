import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetMaintenanceScreen extends StatefulWidget {
  const AssetMaintenanceScreen({super.key});

  @override
  State<AssetMaintenanceScreen> createState() => _AssetMaintenanceScreenState();
}

class _AssetMaintenanceScreenState extends State<AssetMaintenanceScreen> {
  List<dynamic> _realLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceLogs();
  }

  Future<void> _fetchMaintenanceLogs() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getAssetMaintenance();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _realLogs = response['data']['logs'] ?? [];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Asset Repair & Servicing Requests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Track maintenance tickets, repair costs, and vendor servicing status.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Maintenance Logs',
                        onPressed: _fetchMaintenanceLogs,
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
                    child: _isLoading
                        ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primaryCyan)))
                        : _realLogs.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No maintenance logs recorded in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('TICKET ID', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('ASSET', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('ISSUE DESCRIPTION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('COST', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('SERVICING STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _realLogs.map((log) {
                                    final tktId = "TKT-${log['id'] ?? 100}";
                                    final assetDetail = log['asset_detail'] ?? {};
                                    final assetStr = "${assetDetail['asset_code'] ?? 'AST'} (${assetDetail['name'] ?? 'Asset'})";
                                    final serviceType = (log['service_type'] ?? 'General Service').toString();
                                    final cost = "₹${log['cost'] ?? '0.00'}";
                                    final statusStr = (log['status'] ?? 'Completed').toString();

                                    Color color = AppColors.emeraldGreen;
                                    if (statusStr.toUpperCase().contains('PROGRESS')) {
                                      color = AppColors.amberWarning;
                                    }

                                    return _buildMaintRow(tktId, assetStr, serviceType, cost, statusStr, color);
                                  }).toList(),
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
