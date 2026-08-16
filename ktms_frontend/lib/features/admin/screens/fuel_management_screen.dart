import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class FuelManagementScreen extends StatefulWidget {
  const FuelManagementScreen({super.key});

  @override
  State<FuelManagementScreen> createState() => _FuelManagementScreenState();
}

class _FuelManagementScreenState extends State<FuelManagementScreen> {
  List<dynamic> _fuelLogs = [];
  double _totalCost = 0.0;
  double _totalLiters = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFuelLogs();
  }

  Future<void> _fetchFuelLogs() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getFuelLogs();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _fuelLogs = response['data']['fuel_logs'] ?? [];
          _totalCost = (response['data']['total_cost'] ?? 0.0).toDouble();
          _totalLiters = (response['data']['total_liters'] ?? 0.0).toDouble();
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
              title: const Text('Fuel Management Audit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/fuel')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/fuel'),
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
                          Text('Fleet Fuel Expense Audit Ledger', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Audit driver fuel refill logs, pump receipts, and cost per km efficiency.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Fuel Logs',
                        onPressed: _fetchFuelLogs,
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
                        : _fuelLogs.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No fuel logs recorded in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Total Refill Cost: ₹${_totalCost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emeraldGreen, fontSize: 16)),
                                      const SizedBox(width: 24),
                                      Text('Total Fuel Liters: ${_totalLiters.toStringAsFixed(1)} L', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan, fontSize: 16)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor: WidgetStateProperty.all(AppColors.background),
                                      columns: const [
                                        DataColumn(label: Text('DATE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                        DataColumn(label: Text('VEHICLE REGISTRATION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                        DataColumn(label: Text('DRIVER', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                        DataColumn(label: Text('FUEL LITERS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                        DataColumn(label: Text('COST (₹)', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                      ],
                                      rows: _fuelLogs.map((log) {
                                        final date = (log['date'] ?? 'N/A').toString();
                                        final vehicleDetail = log['vehicle_detail'] ?? {};
                                        final regNo = (vehicleDetail['registration_no'] ?? 'Vehicle').toString();

                                        final driverDetail = log['driver_detail'] ?? {};
                                        final driverStr = "${driverDetail['first_name'] ?? 'Driver'} ${driverDetail['last_name'] ?? ''}".trim();
                                        final liters = "${log['fuel_liters'] ?? '0'} L";
                                        final cost = "₹${log['cost_amount'] ?? '0.00'}";

                                        return DataRow(
                                          cells: [
                                            DataCell(Text(date, style: const TextStyle(color: AppColors.textSecondary))),
                                            DataCell(Text(regNo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                            DataCell(Text(driverStr, style: const TextStyle(color: AppColors.textPrimary))),
                                            DataCell(Text(liters, style: const TextStyle(color: AppColors.textPrimary))),
                                            DataCell(Text(cost, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emeraldGreen))),
                                          ],
                                        );
                                      }).toList(),
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
}
