import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedRoleFilter = 'ALL';
  final _searchController = TextEditingController();
  List<dynamic> _realUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRealUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRealUsers() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getUsersList();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _realUsers = response['data']['users'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  List<dynamic> get _filteredUsers {
    final query = _searchController.text.trim().toLowerCase();
    return _realUsers.where((u) {
      final name = "${u['first_name'] ?? ''} ${u['last_name'] ?? ''}".toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      final username = (u['username'] ?? '').toString().toLowerCase();
      final mobile = (u['mobile'] ?? '').toString().toLowerCase();
      final role = (u['role'] ?? '').toString();

      final matchesQuery = query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          username.contains(query) ||
          mobile.contains(query);

      final matchesRole = _selectedRoleFilter == 'ALL' || role == _selectedRoleFilter;

      return matchesQuery && matchesRole;
    }).toList();
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                            tooltip: 'Refresh Database Records',
                            onPressed: _fetchRealUsers,
                          ),
                          const SizedBox(width: 8),
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
                    child: _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(color: AppColors.primaryCyan),
                            ),
                          )
                        : _filteredUsers.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: Text('No users found in database.', style: TextStyle(color: AppColors.textSecondary)),
                                ),
                              )
                            : SingleChildScrollView(
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
                                  rows: _filteredUsers.map((u) {
                                    final firstName = u['first_name'] ?? '';
                                    final lastName = u['last_name'] ?? '';
                                    final fullName = "$firstName $lastName".trim();
                                    final displayTitle = fullName.isNotEmpty ? fullName : (u['username'] ?? 'User');
                                    final details = "${u['username'] ?? ''} | ${u['email'] ?? ''}";
                                    final role = (u['role'] ?? 'USER').toString();
                                    final mobile = (u['mobile'] ?? 'N/A').toString();
                                    final isFrozen = u['is_frozen'] == true;

                                    String statusText = 'Active 🟢';
                                    Color statusColor = AppColors.emeraldGreen;
                                    if (isFrozen) {
                                      statusText = 'Frozen 🔴';
                                      statusColor = AppColors.coralRed;
                                    } else if (role == 'WHOLESALE_CUSTOMER') {
                                      statusText = 'Verified B2B 🟢';
                                      statusColor = AppColors.primaryCyan;
                                    } else if (role == 'DRIVER') {
                                      statusText = 'On Duty 🚚';
                                      statusColor = AppColors.amberWarning;
                                    }

                                    return _buildUserRow(displayTitle, details, role, mobile, statusText, statusColor);
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
