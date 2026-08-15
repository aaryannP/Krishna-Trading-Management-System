import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
              title: const Text('Admin Profile & Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/profile')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Super Admin Credentials & Profile Settings',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your security keys, admin password, and system access rights.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.surfaceCardBorder),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryCyan.withOpacity(0.15),
                                  border: Border.all(color: AppColors.primaryCyan, width: 2),
                                ),
                                child: const Icon(Icons.shield_outlined, color: AppColors.primaryCyan, size: 48),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Aryan Parmar',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.amberWarning.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.amberWarning.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'SUPER ADMIN 👑',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.amberWarning),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Divider(color: AppColors.surfaceCardBorder),
                              const SizedBox(height: 16),

                              _buildInfoRow('Username', 'admin'),
                              _buildInfoRow('Email', 'admin@krishnatrading.com'),
                              _buildInfoRow('Mobile', '+91 8149200499'),
                              _buildInfoRow('Security Key', 'PARM81492004', isHighlight: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Security Form
                      Expanded(
                        flex: 2,
                        child: Container(
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
                                'Change Admin Password',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _oldPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Current Password',
                                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.primaryCyan),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: Icon(Icons.lock_reset_rounded, color: AppColors.primaryCyan),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm New Password',
                                  prefixIcon: Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryCyan),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryCyan,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Admin Password Updated Successfully!'),
                                      backgroundColor: AppColors.emeraldGreen,
                                    ),
                                  );
                                },
                                child: const Text('Update Password', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.amberWarning : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
