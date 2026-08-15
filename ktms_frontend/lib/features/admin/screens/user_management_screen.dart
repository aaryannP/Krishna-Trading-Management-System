import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedRoleFilter = 'ALL';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              title: const Text('Personnel Directory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/users')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/users'),
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
                          Text(
                            'Internal Personnel & Customer Directory',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage all enterprise staff, managers, drivers, and registered client accounts.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCyan,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/users/add'),
                        icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.background, size: 18),
                        label: const Text('Add New Person', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search & Role Filter Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search by Name, Email, Username, or Mobile...',
                              prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryCyan),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          dropdownColor: AppColors.surfaceCard,
                          value: _selectedRoleFilter,
                          style: const TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold, fontSize: 13),
                          underline: const SizedBox(),
                          items: [
                            'ALL',
                            'SUPER_ADMIN',
                            'GENERAL_MANAGER',
                            'FLEET_MANAGER',
                            'STAFF',
                            'DRIVER',
                            'WHOLESALE_CUSTOMER',
                            'RETAIL_CUSTOMER'
                          ]
                              .map((role) => DropdownMenuItem(value: role, child: Text('Role: $role')))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedRoleFilter = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Table
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.background),
                        columns: const [
                          DataColumn(label: Text('NAME', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('USERNAME / EMAIL', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ROLE BADGE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('MOBILE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('STATUS', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                          DataColumn(label: Text('ACTION', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                        ],
                        rows: [
                          _buildUserRow('Aryan Parmar', 'admin | admin@krishnatrading.com', 'SUPER_ADMIN', '+91 8149200499', 'Active 🟢', AppColors.emeraldGreen),
                          _buildUserRow('Ramesh Patel', 'manager | manager@krishnatrading.com', 'GENERAL_MANAGER', '+91 9825011223', 'Active 🟢', AppColors.emeraldGreen),
                          _buildUserRow('Suresh Kumar', 'fleet | fleet@krishnatrading.com', 'FLEET_MANAGER', '+91 9712033445', 'Active 🟢', AppColors.emeraldGreen),
                          _buildUserRow('Vikram Singh', 'vikram_driver', 'DRIVER', '+91 9909055667', 'On Trip 🚚', AppColors.amberWarning),
                          _buildUserRow('Rajesh Packaging', 'rajesh_pack', 'WHOLESALE_CUSTOMER', '+91 9898011234', 'Verified B2B 🟢', AppColors.primaryCyan),
                        ],
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

  DataRow _buildUserRow(String name, String details, String role, String mobile, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        DataCell(Text(details, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryCyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryCyan.withOpacity(0.3)),
            ),
            child: Text(role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryCyan)),
          ),
        ),
        DataCell(Text(mobile, style: const TextStyle(color: AppColors.textSecondary))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.primaryCyan),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
