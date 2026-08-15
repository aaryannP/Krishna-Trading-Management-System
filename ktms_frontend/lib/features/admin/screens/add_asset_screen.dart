import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _assetCodeController = TextEditingController(text: 'AST-${1000 + (DateTime.now().millisecondsSinceEpoch % 8999)}');
  final _assetNameController = TextEditingController();
  final _purchaseCostController = TextEditingController();
  final _vendorController = TextEditingController();
  String _selectedCategory = 'Heavy Machinery';

  @override
  void dispose() {
    _assetCodeController.dispose();
    _assetNameController.dispose();
    _purchaseCostController.dispose();
    _vendorController.dispose();
    super.dispose();
  }

  void _onSaveAsset() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Asset Registered Successfully: ${_assetCodeController.text} (${_assetNameController.text})'),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );
    Navigator.pushReplacementNamed(context, '/admin/assets/dashboard');
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
              title: const Text('Register New Asset', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/assets/add')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/assets/add'),
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
                          Text(
                            'Register Equipment Asset',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Add capital machinery, vehicle assets, or electronics to inventory tracking.',
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
                                  controller: _assetCodeController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Asset Auto Code',
                                    prefixIcon: Icon(Icons.qr_code_rounded, color: AppColors.primaryCyan),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: AppColors.surfaceCard,
                                  value: _selectedCategory,
                                  decoration: const InputDecoration(
                                    labelText: 'Category *',
                                    prefixIcon: Icon(Icons.category_outlined, color: AppColors.primaryCyan),
                                  ),
                                  items: [
                                    'Heavy Machinery',
                                    'Logistics Vehicle',
                                    'Electronic Equipment',
                                    'Godown Tooling'
                                  ].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCategory = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _assetNameController,
                            decoration: const InputDecoration(
                              labelText: 'Asset Title / Name *',
                              prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primaryCyan),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter asset title' : null,
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _purchaseCostController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Purchase Cost (₹) *',
                                    prefixIcon: Icon(Icons.currency_rupee_rounded, color: AppColors.primaryCyan),
                                  ),
                                  validator: (val) => val == null || val.isEmpty ? 'Enter cost' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _vendorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Supplier / Vendor Name',
                                    prefixIcon: Icon(Icons.store_outlined, color: AppColors.primaryCyan),
                                  ),
                                ),
                              ),
                            ],
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
                              onPressed: _onSaveAsset,
                              child: const Text('Save & Register Asset', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 15)),
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
