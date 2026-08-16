import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssignAssetScreen extends StatefulWidget {
  const AssignAssetScreen({super.key});

  @override
  State<AssignAssetScreen> createState() => _AssignAssetScreenState();
}

class _AssignAssetScreenState extends State<AssignAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  List<dynamic> _assets = [];
  List<dynamic> _users = [];
  int? _selectedAssetId;
  int? _selectedUserId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    setState(() => _isLoading = true);
    final assetsRes = await ApiService.getAssets();
    final usersRes = await ApiService.getUsersList();

    if (mounted) {
      final assetList = assetsRes['data']?['assets'] ?? [];
      final userList = usersRes['data']?['users'] ?? [];

      setState(() {
        _assets = assetList;
        _users = userList;
        if (assetList.isNotEmpty) _selectedAssetId = assetList[0]['id'];
        if (userList.isNotEmpty) _selectedUserId = userList[0]['id'];
        _isLoading = false;
      });
    }
  }

  void _onAssignSubmit() async {
    if (!_formKey.currentState!.validate() || _selectedAssetId == null || _selectedUserId == null) return;

    final data = {
      'asset': _selectedAssetId,
      'user': _selectedUserId,
      'notes': _remarksController.text.trim(),
    };

    final response = await ApiService.assignAsset(data);
    if (!mounted) return;

    if (response['statusCode'] == 201 || response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset Successfully Assigned in Database!'),
          backgroundColor: AppColors.emeraldGreen,
        ),
      );
      Navigator.pushReplacementNamed(context, '/admin/assets/history');
    } else {
      final errorMsg = response['data']?['message'] ?? response['data']?['errors']?.toString() ?? 'Failed to assign asset';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $errorMsg'),
          backgroundColor: AppColors.coralRed,
        ),
      );
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
              title: const Text('Assign Asset to Personnel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/assign')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/assign'),
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
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/assets/dashboard'),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assign Equipment Asset', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Handover company equipment or vehicles to drivers and staff members.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<int>(
                            dropdownColor: AppColors.surfaceCard,
                            value: _selectedAssetId,
                            decoration: const InputDecoration(
                              labelText: 'Select Equipment Asset *',
                              prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primaryCyan),
                            ),
                            items: _assets
                                .map((a) => DropdownMenuItem<int>(
                                      value: a['id'] as int,
                                      child: Text("${a['asset_code'] ?? 'AST'} - ${a['name'] ?? 'Asset'}"),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedAssetId = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<int>(
                            dropdownColor: AppColors.surfaceCard,
                            value: _selectedUserId,
                            decoration: const InputDecoration(
                              labelText: 'Select Assignee Personnel / Driver *',
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryCyan),
                            ),
                            items: _users
                                .map((u) => DropdownMenuItem<int>(
                                      value: u['id'] as int,
                                      child: Text("${u['first_name'] ?? ''} ${u['last_name'] ?? ''} (${u['role'] ?? 'Staff'})".trim()),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedUserId = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _remarksController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Handover Remarks / Condition Notes',
                              prefixIcon: Icon(Icons.notes_rounded, color: AppColors.primaryCyan),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                              onPressed: _onAssignSubmit,
                              child: const Text('Confirm Asset Assignment', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                          ),
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
}
