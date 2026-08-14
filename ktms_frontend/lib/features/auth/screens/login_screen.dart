import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import 'admin_security_key_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'SUPER_ADMIN';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _executeLogin({String? adminKey}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      adminSecurityKey: adminKey,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome ${authProvider.currentUser?.firstName}! Login Successful.'),
          backgroundColor: AppColors.emeraldGreen,
        ),
      );
      Navigator.pushReplacementNamed(context, '/welcome');
    } else {
      if (authProvider.errorMessage?.contains('Admin Security Key Required') == true) {
        // Show Admin Key Popup
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AdminSecurityKeyDialog(
            onSubmit: (key) => _executeLogin(adminKey: key),
          ),
        );
      } else if (authProvider.errorMessage?.contains('frozen for 24 hours') == true) {
        Navigator.pushReplacementNamed(context, '/freeze-24hr');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login Failed'),
            backgroundColor: AppColors.coralRed,
          ),
        );
      }
    }
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == 'SUPER_ADMIN' || _selectedRole == 'GENERAL_MANAGER') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AdminSecurityKeyDialog(
          onSubmit: (key) => _executeLogin(adminKey: key),
        ),
      );
    } else {
      _executeLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.surfaceCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.factory_rounded,
                            color: AppColors.primaryCyan,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'KRISHNA TRADING ERP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Enterprise Logistics & B2B ERP System',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Select Portal Access Role',
                      prefixIcon: Icon(Icons.shield_outlined, color: AppColors.primaryCyan),
                    ),
                    dropdownColor: AppColors.surfaceCard,
                    items: const [
                      DropdownMenuItem(value: 'SUPER_ADMIN', child: Text('Super Admin')),
                      DropdownMenuItem(value: 'GENERAL_MANAGER', child: Text('General Manager')),
                      DropdownMenuItem(value: 'FLEET_MANAGER', child: Text('Fleet Manager')),
                      DropdownMenuItem(value: 'STAFF', child: Text('Shop / Warehouse Staff')),
                      DropdownMenuItem(value: 'DRIVER', child: Text('Driver Logistics Staff')),
                      DropdownMenuItem(value: 'RETAIL_CUSTOMER', child: Text('Retail B2C Customer')),
                      DropdownMenuItem(value: 'WHOLESALE_CUSTOMER', child: Text('Wholesale B2B Customer')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username or Email',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryCyan),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryCyan),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter password' : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _onLoginPressed,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.background,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Login to Dashboard'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary)),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                        child: const Text('Register B2B/B2C', style: TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
