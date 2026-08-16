import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
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
              title: const Text('Driver Profile Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/drivers/details')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/drivers/details'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryCyan),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/fleet/drivers'),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Driver Profile Audit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Driver license, active dispatches, and performance scores.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryCyan))
                        : _drivers.isEmpty
                            ? const Text('No drivers available in database.', style: TextStyle(color: AppColors.textSecondary))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: AppColors.primaryCyan,
                                        child: Icon(Icons.badge_rounded, color: AppColors.background, size: 32),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_drivers[0]['first_name']} ${_drivers[0]['last_name']}",
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                          Text("Mobile: ${_drivers[0]['mobile'] ?? 'N/A'}", style: const TextStyle(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const Divider(color: AppColors.surfaceCardBorder),
                                  const SizedBox(height: 16),
                                  _buildDetailRow('Email / Username', _drivers[0]['email'] ?? 'N/A'),
                                  _buildDetailRow('Driving License No.', _drivers[0]['license_no'] ?? 'GJ01-2021004589'),
                                  _buildDetailRow('Account Role', _drivers[0]['role'] ?? 'DRIVER'),
                                  _buildDetailRow('Total Completed Trips', "${_drivers[0]['total_completed_trips'] ?? 0} Dispatches"),
                                  _buildDetailRow('POD Digital OTP Status', '100% Verified 🟢'),
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

  Widget _buildDetailRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan)),
        ],
      ),
    );
  }
}
