import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  const VehicleMaintenanceScreen({super.key});

  @override
  State<VehicleMaintenanceScreen> createState() => _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaintenance();
  }

  Future<void> _fetchMaintenance() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getAssetMaintenance();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _logs = response['data']['logs'] ?? [];
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
              title: const Text('Vehicle Garage Repair Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/maintenance')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/maintenance'),
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
                          Text('Fleet Vehicle Garage Maintenance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Service tickets, engine oil changes, and mechanic garage repair costs.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Repair Logs',
                        onPressed: _fetchMaintenance,
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
                        : _logs.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No vehicle maintenance records in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('TICKET CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('VEHICLE / ASSET', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('SERVICE TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('COST (₹)', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('SERVICING STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _logs.map((l) {
                                    final tkt = "TKT-${l['id'] ?? 101}";
                                    final assetDetail = l['asset_detail'] ?? {};
                                    final name = "${assetDetail['asset_code'] ?? 'AST'} (${assetDetail['name'] ?? 'Vehicle'})";
                                    final service = (l['service_type'] ?? 'Oil & Filter Replacement').toString();
                                    final cost = "₹${l['cost'] ?? '0.00'}";
                                    final statusStr = (l['status'] ?? 'Completed').toString();

                                    Color statusColor = AppColors.emeraldGreen;
                                    if (statusStr.toUpperCase().contains('PROGRESS')) {
                                      statusColor = AppColors.amberWarning;
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(tkt, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(Text(name, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(service, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(Text(cost, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                            child: Text(statusStr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
                                          ),
                                        ),
                                      ],
                                    );
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
}
