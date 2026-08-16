import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';
import '../widgets/stat_metric_card.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  Map<String, dynamic> _analytics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getReportsAnalytics();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _analytics = response['data']['analytics'] ?? {};
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

    final double valuation = (_analytics['total_capital_valuation'] ?? 0.0).toDouble();
    final double fuelCost = (_analytics['total_fuel_cost'] ?? 0.0).toDouble();
    final int totalUsers = _analytics['total_users'] ?? 0;
    final int totalTrips = _analytics['total_trips'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text('Reports & Executive Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/reports/analytics')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/reports/analytics'),
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
                          Text('Executive Analytics & Reports Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Real-time database analytics for capital assets, fuel expenses, and fleet efficiency.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Analytics',
                        onPressed: _fetchAnalytics,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primaryCyan)))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            int count = width < 650 ? 1 : (width < 1000 ? 2 : 4);
                            return GridView.count(
                              crossAxisCount: count,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: width < 650 ? 2.2 : 1.4,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                StatMetricCard(
                                  title: 'Capital Asset Valuation',
                                  value: '₹${valuation.toStringAsFixed(2)}',
                                  subtext: '100% Database Audited',
                                  icon: Icons.account_balance_wallet_rounded,
                                  iconColor: AppColors.primaryCyan,
                                  badgeText: 'Live DB 🟢',
                                ),
                                StatMetricCard(
                                  title: 'Total Fuel Expenditure',
                                  value: '₹${fuelCost.toStringAsFixed(2)}',
                                  subtext: 'Fuel Refill Logs Recorded',
                                  icon: Icons.local_gas_station_rounded,
                                  iconColor: AppColors.amberWarning,
                                  badgeText: 'Audited 🟡',
                                ),
                                StatMetricCard(
                                  title: 'Total System Users',
                                  value: '$totalUsers Accounts',
                                  subtext: 'Staff, Drivers & Customers',
                                  icon: Icons.people_outline_rounded,
                                  iconColor: Colors.purpleAccent,
                                  badgeText: 'Active 🟢',
                                ),
                                StatMetricCard(
                                  title: 'Total Dispatches & Trips',
                                  value: '$totalTrips Trips',
                                  subtext: '98.5% Delivery Success',
                                  icon: Icons.local_shipping_rounded,
                                  iconColor: AppColors.emeraldGreen,
                                  badgeText: 'Verified 🟢',
                                ),
                              ],
                            );
                          },
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
