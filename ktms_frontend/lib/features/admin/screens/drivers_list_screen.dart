import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class DriversListScreen extends StatefulWidget {
  const DriversListScreen({super.key});

  @override
  State<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  List<dynamic> _drivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getDrivers();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _drivers = response['data']['drivers'] ?? [];
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
              title: const Text('Drivers Directory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/drivers')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/drivers'),
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
                          Text('Active Drivers Directory', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Logistics drivers, trip assignments, and digital POD verification status.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Drivers',
                        onPressed: _fetchDrivers,
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
                        : _drivers.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No drivers registered in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('DRIVER NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('USERNAME / EMAIL', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('MOBILE NUMBER', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('COMPLETED TRIPS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _drivers.map((d) {
                                    final fullName = "${d['first_name'] ?? ''} ${d['last_name'] ?? ''}".trim();
                                    final name = fullName.isNotEmpty ? fullName : (d['username'] ?? 'Driver');
                                    final email = "${d['username'] ?? ''} | ${d['email'] ?? ''}";
                                    final mobile = (d['mobile'] ?? 'N/A').toString();
                                    final completed = "${d['total_completed_trips'] ?? 0} Trips";
                                    final activeTrip = d['active_trip_code'];

                                    String statusText = 'Available 🟢';
                                    Color statusColor = AppColors.emeraldGreen;
                                    if (activeTrip != null) {
                                      statusText = 'On Route 🚚 ($activeTrip)';
                                      statusColor = AppColors.amberWarning;
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                                        DataCell(Text(email, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(Text(mobile, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(Text(completed, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                            child: Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
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
