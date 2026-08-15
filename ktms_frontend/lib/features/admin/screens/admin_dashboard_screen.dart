import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';
import '../widgets/stat_metric_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: AppColors.surfaceCard,
              title: const Text(
                'Executive Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              centerTitle: false,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.emeraldGreen.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: AppColors.emeraldGreen, size: 8),
                      SizedBox(width: 6),
                      Text(
                        'Live 🟢',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      drawer: !isDesktop
          ? const Drawer(
              child: AdminSidebarNavigation(currentRoute: '/admin/dashboard'),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            const AdminSidebarNavigation(currentRoute: '/admin/dashboard'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner / Welcome Header
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // 4 Stat Metric Cards (Responsive Grid)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 4;
                      if (width < 650) {
                        crossAxisCount = 1;
                      } else if (width < 1000) {
                        crossAxisCount = 2;
                      }

                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: width < 650 ? 2.2 : (width < 1000 ? 1.6 : 1.4),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          StatMetricCard(
                            title: 'Total Monthly Sales',
                            value: '₹48,25,400',
                            subtext: '1,420 Bales & Cartons Dispatched',
                            icon: Icons.payments_rounded,
                            iconColor: AppColors.primaryCyan,
                            badgeText: '+14.2%',
                            isPositiveBadge: true,
                          ),
                          StatMetricCard(
                            title: 'Stock In Hand',
                            value: '1,280 Bales',
                            subtext: 'Godown A: 850 | Godown B: 430',
                            icon: Icons.inventory_rounded,
                            iconColor: AppColors.amberWarning,
                            badgeText: 'Optimal',
                            isPositiveBadge: true,
                          ),
                          StatMetricCard(
                            title: 'Fleet Vehicles',
                            value: '8 / 10 Active',
                            subtext: '2 Vehicles in Service Repair',
                            icon: Icons.local_shipping_rounded,
                            iconColor: AppColors.emeraldGreen,
                            badgeText: '80% Load',
                            isPositiveBadge: true,
                          ),
                          StatMetricCard(
                            title: 'Active Personnel',
                            value: '28 Staff',
                            subtext: 'GM: 2 | Fleet: 3 | Drivers: 8 | Staff: 15',
                            icon: Icons.badge_rounded,
                            iconColor: Colors.purpleAccent,
                            badgeText: 'Full Crew',
                            isPositiveBadge: true,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Middle Section: Revenue Chart & Quick Actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildRevenueOverviewCard(),
                      ),
                      if (screenWidth > 900) ...[
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: _buildQuickActionsCard(context),
                        ),
                      ],
                    ],
                  ),

                  if (screenWidth <= 900) ...[
                    const SizedBox(height: 20),
                    _buildQuickActionsCard(context),
                  ],

                  const SizedBox(height: 28),

                  // Bottom Section: Recent Transactions & System Security Status
                  _buildRecentOrdersTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceCard,
            AppColors.primaryCyan.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Welcome back, Super Admin! ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text('👋', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Krishna Trading Management ERP System | ',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.amberWarning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.amberWarning.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'KEY: PARM81492004',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amberWarning,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/admin/users/add');
            },
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.background, size: 18),
            label: const Text(
              'Add New Staff',
              style: TextStyle(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Revenue vs Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Monthly Breakdown & Cashflow Statement',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              DropdownButton<String>(
                dropdownColor: AppColors.surfaceCard,
                value: 'This Month',
                style: const TextStyle(color: AppColors.primaryCyan, fontSize: 13, fontWeight: FontWeight.bold),
                underline: const SizedBox(),
                items: ['This Month', 'Last 3 Months', 'Year 2026']
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (val) {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Simulated Visual Revenue Bars
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Mon', 0.6, AppColors.primaryCyan),
                _buildBar('Tue', 0.85, AppColors.primaryCyan),
                _buildBar('Wed', 0.45, AppColors.amberWarning),
                _buildBar('Thu', 0.95, AppColors.primaryCyan),
                _buildBar('Fri', 0.70, AppColors.primaryCyan),
                _buildBar('Sat', 0.90, AppColors.emeraldGreen),
                _buildBar('Sun', 0.30, AppColors.textDisabled),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 130 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Operations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            'Add Person / Staff',
            Icons.person_add_rounded,
            AppColors.primaryCyan,
            '/admin/users/add',
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            'Register New Asset',
            Icons.add_box_rounded,
            AppColors.emeraldGreen,
            '/admin/assets/add',
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            'Assign Asset to Driver',
            Icons.assignment_ind_rounded,
            AppColors.amberWarning,
            '/admin/assets/assign',
          ),
          const SizedBox(height: 10),
          _buildActionButton(
            context,
            'Fleet Logistics Dashboard',
            Icons.local_shipping_rounded,
            Colors.purpleAccent,
            '/admin/fleet/dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, String route) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushReplacementNamed(context, route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersTable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Enterprise Orders & Dispatches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'View All Orders →',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.background),
              columns: const [
                DataColumn(label: Text('ORDER ID', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                DataColumn(label: Text('CLIENT NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                DataColumn(label: Text('TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                DataColumn(label: Text('QUANTITY / WT', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                DataColumn(label: Text('TOTAL AMOUNT', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
              ],
              rows: [
                _buildDataRow('ORD-8821', 'Rajesh Packaging Pvt Ltd', 'B2B Wholesale', '250 Bales (16.2 Tons)', '₹8,45,000', 'Dispatched 🚚', AppColors.emeraldGreen),
                _buildDataRow('ORD-8820', 'Shree Ram Traders', 'B2B Wholesale', '100 Cartons (800 Kg)', '₹2,10,000', 'Stock Locked 🔒', AppColors.amberWarning),
                _buildDataRow('ORD-8819', 'Amit Kumar', 'Retail B2C', '5 Cartons (40 Kg)', '₹14,500', 'Delivered 🟢', AppColors.primaryCyan),
                _buildDataRow('ORD-8818', 'Gujarat Agro Mills', 'B2B Wholesale', '500 Bales (32.5 Tons)', '₹16,80,000', 'Dispatched 🚚', AppColors.emeraldGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String id, String client, String type, String qty, String amount, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
        DataCell(Text(client, style: const TextStyle(color: AppColors.textPrimary))),
        DataCell(Text(type, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(qty, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
            ),
          ),
        ),
      ],
    );
  }
}
