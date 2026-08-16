import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  List<dynamic> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getVehicles();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _vehicles = response['data']['vehicles'] ?? [];
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
              title: const Text('Fleet Vehicles Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/vehicles')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/vehicles'),
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
                          Text('Fleet Vehicles Master Inventory', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Registered trucks, tempos, chhota hathis, and sample scooters.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                            tooltip: 'Refresh Vehicles',
                            onPressed: _fetchVehicles,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/admin/fleet/vehicles/add'),
                            icon: const Icon(Icons.add, color: AppColors.background),
                            label: const Text('Add Vehicle', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
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
                        : _vehicles.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No fleet vehicles registered in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('REGISTRATION NO.', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('VEHICLE TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('PAYLOAD CAPACITY (KG)', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('PUC EXPIRY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _vehicles.map((v) {
                                    final regNo = (v['registration_no'] ?? 'GJ-01-XX').toString();
                                    final vType = (v['vehicle_type_display'] ?? v['vehicle_type'] ?? 'Vehicle').toString();
                                    final capacity = "${v['payload_capacity_kg'] ?? '500'} Kg";
                                    final puc = (v['puc_expiry'] ?? 'N/A').toString();

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(regNo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(Text(vType, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(capacity, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                                        DataCell(Text(puc, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: AppColors.emeraldGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                            child: const Text('Active 🟢', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen)),
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
