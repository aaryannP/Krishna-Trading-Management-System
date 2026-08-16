import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
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
              title: const Text('Trip POD Inspection Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/trips/details')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/trips/details'),
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
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/fleet/trips'),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trip Inspection & Digital POD Verification', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Odometer KM audit, cargo weight, and customer POD signature pad.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                        : _trips.isEmpty
                            ? const Text('No trips recorded in database yet.', style: TextStyle(color: AppColors.textSecondary))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_trips[0]['trip_code'] ?? 'TRIP-101', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryCyan)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(color: AppColors.emeraldGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                        child: Text(_trips[0]['status_display'] ?? 'DISPATCHED', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emeraldGreen)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(color: AppColors.surfaceCardBorder),
                                  const SizedBox(height: 16),
                                  _buildDetailRow('Origin Warehouse', _trips[0]['origin'] ?? 'Krishna Trading Warehouse'),
                                  _buildDetailRow('Destination Delivery Point', _trips[0]['destination'] ?? 'B2B Client Godown'),
                                  _buildDetailRow('Gross Payload Cargo Weight', "${_trips[0]['total_gross_weight_kg'] ?? '500'} Kg"),
                                  _buildDetailRow('Customer POD Signature', _trips[0]['pod_otp_verified'] == true ? 'OTP Verified 🟢' : 'Digitally Signed ✍️'),
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
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
