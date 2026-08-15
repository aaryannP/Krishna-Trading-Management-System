import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'STAFF';
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAddPersonSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final response = await ApiService.register(
      username: email.contains('@') ? email.split('@')[0] : email,
      email: email,
      password: _passwordController.text.trim(),
      confirmPassword: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _mobileController.text.trim(),
      role: _selectedRole,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Person Account Created Successfully! Derived Username: ${_emailController.text.split('@')[0]}'),
          backgroundColor: AppColors.emeraldGreen,
        ),
      );
      Navigator.pushReplacementNamed(context, '/admin/users');
    } else {
      final errorMsg = response['data']?['message'] ?? response['data']?['errors']?.toString() ?? 'Failed to create person';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
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
              title: const Text('Add Person / Staff Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/users/add')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/users/add'),
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
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/users'),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Internal Personnel Account',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Assign roles and credentials for Managers, Shop Staff, Drivers, or Clients.',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First Name *',
                                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryCyan),
                                  ),
                                  validator: (val) => val == null || val.isEmpty ? 'Enter first name' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name *',
                                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryCyan),
                                  ),
                                  validator: (val) => val == null || val.isEmpty ? 'Enter last name' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address (Username will be auto-derived) *',
                              prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryCyan),
                            ),
                            validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                            onChanged: (val) => setState(() {}),
                          ),
                          if (_emailController.text.contains('@')) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Derived Username: ${_emailController.text.split('@')[0]}',
                              style: const TextStyle(fontSize: 12, color: AppColors.amberWarning, fontWeight: FontWeight.bold),
                            ),
                          ],
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile Number *',
                                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryCyan),
                                  ),
                                  validator: (val) => val == null || val.length < 10 ? 'Enter valid mobile' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: AppColors.surfaceCard,
                                  value: _selectedRole,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Role *',
                                    prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryCyan),
                                  ),
                                  items: [
                                    DropdownMenuItem(value: 'GENERAL_MANAGER', child: Text('General Manager')),
                                    DropdownMenuItem(value: 'FLEET_MANAGER', child: Text('Fleet Manager')),
                                    DropdownMenuItem(value: 'STAFF', child: Text('Shop / Warehouse Staff')),
                                    DropdownMenuItem(value: 'DRIVER', child: Text('Driver')),
                                    DropdownMenuItem(value: 'WHOLESALE_CUSTOMER', child: Text('B2B Wholesale Customer')),
                                    DropdownMenuItem(value: 'RETAIL_CUSTOMER', child: Text('B2C Retail Customer')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedRole = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Initial Password *',
                              prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.primaryCyan),
                            ),
                            validator: (val) => val == null || val.length < 6 ? 'Password min 6 chars' : null,
                          ),
                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryCyan,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _isLoading ? null : _onAddPersonSubmit,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: AppColors.background, strokeWidth: 2.5),
                                    )
                                  : const Text('Create Personnel Account', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 15)),
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
