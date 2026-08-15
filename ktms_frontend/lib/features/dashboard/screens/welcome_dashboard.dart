import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class WelcomeDashboard extends StatelessWidget {
  const WelcomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.factory_rounded, color: AppColors.primaryCyan, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'KRISHNA TRADING ERP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.coralRed),
            tooltip: 'Logout',
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.surfaceCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.emeraldGreen,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome, ${user?.firstName ?? 'Aryan'} ${user?.lastName ?? 'Parmar'}!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? 'admin@krishnatrading.com',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceCardBorder),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Username', user?.username ?? 'admin'),
                      const Divider(color: AppColors.surfaceCardBorder, height: 24),
                      _buildInfoRow('Portal Access Role', user?.role ?? 'SUPER_ADMIN', isBadge: true),
                      const Divider(color: AppColors.surfaceCardBorder, height: 24),
                      _buildInfoRow('Account Status', 'Active 🟢', isStatus: true),
                      if (user?.adminSecurityKey != null) ...[
                        const Divider(color: AppColors.surfaceCardBorder, height: 24),
                        _buildInfoRow('Admin Security Key', user!.adminSecurityKey!, isKey: true),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/admin/dashboard');
                    },
                    icon: const Icon(Icons.dashboard_rounded, color: AppColors.background),
                    label: const Text(
                      'Enter Super Admin ERP Suite 🚀',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coralRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.power_settings_new_rounded),
                    label: const Text('Logout Session'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBadge = false, bool isStatus = false, bool isKey = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryCyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryCyan.withOpacity(0.4)),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryCyan,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        else if (isStatus)
          Text(
            value,
            style: const TextStyle(
              color: AppColors.emeraldGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        else if (isKey)
          Text(
            value,
            style: const TextStyle(
              color: AppColors.amberWarning,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.5,
              fontFamily: 'monospace',
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
