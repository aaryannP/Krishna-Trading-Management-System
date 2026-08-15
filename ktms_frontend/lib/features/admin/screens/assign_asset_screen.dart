import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AssignAssetScreen extends StatefulWidget {
  const AssignAssetScreen({super.key});

  @override
  State<AssignAssetScreen> createState() => _AssignAssetScreenState();
}

class _AssignAssetScreenState extends State<AssignAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedAsset = 'AST-1003 - Honda Activa 6G (50kg Sample Cargo)';
  String _selectedStaff = 'Vikram Singh (Driver)';
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  void _onAssignSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Asset $_selectedAsset Successfully Assigned to $_selectedStaff!'),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );
    Navigator.pushReplacementNamed(context, '/admin/assets/history');
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
                          DropdownButtonFormField<String>(
                            dropdownColor: AppColors.surfaceCard,
                            value: _selectedAsset,
                            decoration: const InputDecoration(
                              labelText: 'Select Equipment Asset *',
                              prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primaryCyan),
                            ),
                            items: [
                              'AST-1003 - Honda Activa 6G (50kg Sample Cargo)',
                              'AST-1004 - Mahindra Supro Chhota Hathi (500kg)',
                              'AST-1005 - Handheld Barcode Scanner 01',
                            ].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedAsset = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            dropdownColor: AppColors.surfaceCard,
                            value: _selectedStaff,
                            decoration: const InputDecoration(
                              labelText: 'Select Assignee Personnel / Driver *',
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryCyan),
                            ),
                            items: [
                              'Vikram Singh (Driver)',
                              'Mahesh Kumar (Driver)',
                              'Ramesh Patel (Factory GM)',
                              'Suresh Kumar (Fleet Manager)',
                            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedStaff = val);
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
