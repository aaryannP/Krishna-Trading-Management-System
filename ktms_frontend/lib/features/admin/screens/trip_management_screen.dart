import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class TripManagementScreen extends StatefulWidget {
  const TripManagementScreen({super.key});

  @override
  State<TripManagementScreen> createState() => _TripManagementScreenState();
}

class _TripManagementScreenState extends State<TripManagementScreen> {
  List<dynamic> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getTrips();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _trips = response['data']['trips'] ?? [];
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
              title: const Text('Trip Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/trips')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/trips'),
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
                          Text('Trip Dispatch & Route Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Live dispatch tracking, route gross weight, and POD digital signatures.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Trips',
                        onPressed: _fetchTrips,
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
                        : _trips.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No trip dispatches recorded in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('TRIP CODE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('DESTINATION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('GROSS WEIGHT', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('DRIVER & VEHICLE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _trips.map((t) {
                                    final code = (t['trip_code'] ?? 'TRIP-101').toString();
                                    final dest = (t['destination'] ?? 'Krishna Trading Godown B').toString();
                                    final weight = "${t['total_gross_weight_kg'] ?? '500'} Kg";

                                    final driverDetail = t['driver_detail'] ?? {};
                                    final vehicleDetail = t['vehicle_detail'] ?? {};
                                    final driverStr = "${driverDetail['first_name'] ?? 'Driver'} | ${vehicleDetail['registration_no'] ?? 'Vehicle'}";
                                    final statusStr = (t['status_display'] ?? t['status'] ?? 'DISPATCHED').toString();

                                    Color statusColor = AppColors.amberWarning;
                                    if (statusStr.toUpperCase().contains('DELIVERED')) {
                                      statusColor = AppColors.emeraldGreen;
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(Text(dest, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(weight, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                                        DataCell(Text(driverStr, style: const TextStyle(color: AppColors.textSecondary))),
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
