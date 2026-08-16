import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  Map<String, dynamic> _config = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getSystemSettings();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _config = response['data']['system_config'] ?? {};
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
              title: const Text('System Security & Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/system/settings')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/system/settings'),
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
                          Text('Master Admin System & Security Control', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Master Security Passkey, 48-Hour Ban engine, and 24-Hour Account Freeze triggers.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh System Settings',
                        onPressed: _fetchSettings,
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
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.shield_rounded, color: AppColors.emeraldGreen, size: 28),
                                  SizedBox(width: 12),
                                  Text('Security Engine Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: AppColors.surfaceCardBorder),
                              const SizedBox(height: 16),
                              _buildSettingItem('Enterprise ERP System Name', _config['system_name'] ?? 'KTMS v2.0', AppColors.primaryCyan),
                              _buildSettingItem('Master Admin Security Passkey', _config['admin_passkey'] ?? 'PARM81492004', AppColors.emeraldGreen),
                              _buildSettingItem('48-Hour OTP Failed Ban Engine', 'Active 🟢 (48-Hr Lockdown)', AppColors.emeraldGreen),
                              _buildSettingItem('24-Hour Passkey Failed Freeze', 'Active 🟢 (24-Hr Freeze)', AppColors.emeraldGreen),
                              _buildSettingItem('Database Architecture', _config['database_engine'] ?? 'Django PostgreSQL', AppColors.textPrimary),
                              _buildSettingItem('Backend REST API Server', _config['api_base_url'] ?? 'http://127.0.0.1:8000/api/v1/', AppColors.textSecondary),
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

  Widget _buildSettingItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
