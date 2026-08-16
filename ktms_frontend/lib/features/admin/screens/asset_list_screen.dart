import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key});

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  List<dynamic> _realAssets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getAssets();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _realAssets = response['data']['assets'] ?? [];
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                            tooltip: 'Refresh Assets',
                            onPressed: _fetchAssets,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/admin/assets/add'),
                            icon: const Icon(Icons.add, color: AppColors.background),
                            label: const Text('Add Asset', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                          ),
                        ],
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
                        : _realAssets.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No assets registered in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('ASSET CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('ASSET NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('CATEGORY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('MODEL / SERIAL', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('COST', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _realAssets.map((asset) {
                                    final code = (asset['asset_code'] ?? 'AST-0000').toString();
                                    final name = (asset['name'] ?? 'Unnamed Asset').toString();
                                    final category = (asset['category_display'] ?? asset['category'] ?? 'General').toString();
                                    final modelSerial = "${asset['model_no'] ?? ''} ${asset['serial_no'] ?? ''}".trim();
                                    final cost = "₹${asset['purchase_cost'] ?? '0.00'}";
                                    final statusStr = (asset['status_display'] ?? asset['status'] ?? 'AVAILABLE').toString();

                                    Color statusColor = AppColors.emeraldGreen;
                                    if (statusStr.toUpperCase().contains('MAINTENANCE')) {
                                      statusColor = AppColors.amberWarning;
                                    } else if (statusStr.toUpperCase().contains('DAMAGED')) {
                                      statusColor = AppColors.coralRed;
                                    }

                                    return _buildRow(code, name, category, modelSerial.isNotEmpty ? modelSerial : 'N/A', cost, statusStr, statusColor);
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
