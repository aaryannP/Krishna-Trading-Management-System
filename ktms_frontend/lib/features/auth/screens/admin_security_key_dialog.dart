import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminSecurityKeyDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const AdminSecurityKeyDialog({super.key, required this.onSubmit});

  @override
  State<AdminSecurityKeyDialog> createState() => _AdminSecurityKeyDialogState();
}

class _AdminSecurityKeyDialogState extends State<AdminSecurityKeyDialog> {
  final TextEditingController _keyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.amberWarning, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amberWarning.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: AppColors.amberWarning,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin Security Authorization',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter Dynamic Admin Security Key\n(Formula: LASTNAME_4_UPPER + MOBILE_LAST_4 + BIRTH_YEAR)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _keyController,
                style: const TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'SECURITY KEY (e.g. PARM81492004)',
                  prefixIcon: Icon(Icons.key, color: AppColors.amberWarning),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter Admin Security Key';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.surfaceCardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amberWarning,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          widget.onSubmit(_keyController.text.trim());
                        }
                      },
                      child: const Text('Authorize', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
