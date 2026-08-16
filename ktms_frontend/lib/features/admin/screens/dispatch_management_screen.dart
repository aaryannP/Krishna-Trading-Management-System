import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class DispatchManagementScreen extends StatefulWidget {
  const DispatchManagementScreen({super.key});

  @override
  State<DispatchManagementScreen> createState() => _DispatchManagementScreenState();
}

class _DispatchManagementScreenState extends State<DispatchManagementScreen> {
  List<dynamic> _dispatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDispatches();
  }

  Future<void> _fetchDispatches() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getDispatches();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _dispatches = response['data']['dispatches'] ?? [];
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
              title: const Text('Dispatch Operations Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/dispatch')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/dispatch'),
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
                          Text('Dispatch Operations & Payload Matcher', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Match order gross cargo weight to optimal vehicle type (Activa, Chhota Hathi, Tempo, Truck).', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Dispatches',
                        onPressed: _fetchDispatches,
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
                        : _dispatches.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No active dispatches in database currently.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('DISPATCH CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('ORIGIN', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('DESTINATION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('WEIGHT (KG)', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _dispatches.map((d) {
                                    final code = (d['trip_code'] ?? 'DISP-101').toString();
                                    final origin = (d['origin'] ?? 'Godown A').toString();
                                    final dest = (d['destination'] ?? 'Client Point').toString();
                                    final weight = "${d['total_gross_weight_kg'] ?? '500'} Kg";
                                    final statusStr = (d['status_display'] ?? d['status'] ?? 'In Transit').toString();

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(Text(origin, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(dest, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(weight, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: AppColors.amberWarning.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                            child: Text(statusStr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.amberWarning)),
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
