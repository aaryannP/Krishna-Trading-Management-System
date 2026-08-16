import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _regNoController = TextEditingController();
  final _capacityController = TextEditingController(text: '500');
  String _selectedType = 'CHHOTA_HATHI';
  List<dynamic> _assets = [];
  int? _selectedAssetId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _regNoController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _loadAssets() async {
    final response = await ApiService.getAssets();
    if (mounted) {
      final list = response['data']?['assets'] ?? [];
      setState(() {
        _assets = list;
        if (list.isNotEmpty) _selectedAssetId = list[0]['id'];
        _isLoading = false;
      });
    }
  }

  void _onSaveVehicle() async {
    if (!_formKey.currentState!.validate() || _selectedAssetId == null) return;

    final data = {
      'asset': _selectedAssetId,
      'registration_no': _regNoController.text.trim().toUpperCase(),
      'vehicle_type': _selectedType,
      'payload_capacity_kg': double.tryParse(_capacityController.text.trim()) ?? 500.0,
    };

    final response = await ApiService.addVehicle(data);
    if (!mounted) return;

    if (response['statusCode'] == 201 || response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle ${data['registration_no']} Registered Successfully!'),
          backgroundColor: AppColors.emeraldGreen,
        ),
      );
      Navigator.pushReplacementNamed(context, '/admin/fleet/vehicles');
    } else {
      final errorMsg = response['data']?['message'] ?? response['data']?['errors']?.toString() ?? 'Failed to register vehicle';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMsg'), backgroundColor: AppColors.coralRed),
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
              title: const Text('Register Fleet Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/vehicles/add')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/vehicles/add'),
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
                        onPressed: () => Navigator.pushReplacementNamed(context, '/admin/fleet/vehicles'),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register New Fleet Vehicle', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Link equipment asset code and configure payload capacity.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                              labelText: 'Link Capital Asset *',
                              prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primaryCyan),
                            ),
                            items: _assets.map((a) => DropdownMenuItem<int>(value: a['id'] as int, child: Text("${a['asset_code']} - ${a['name']}"))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedAssetId = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _regNoController,
                            decoration: const InputDecoration(
                              labelText: 'Registration No. (e.g. GJ-01-KT-8149) *',
                              prefixIcon: Icon(Icons.pin_outlined, color: AppColors.primaryCyan),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter registration number' : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            dropdownColor: AppColors.surfaceCard,
                            value: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Category *',
                              prefixIcon: Icon(Icons.directions_car_outlined, color: AppColors.primaryCyan),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'ACTIVA', child: Text('Activa / Scooter (Up to 50 Kg)')),
                              DropdownMenuItem(value: 'CHHOTA_HATHI', child: Text('Chhota Hathi / Tata Ace (Up to 500 Kg)')),
                              DropdownMenuItem(value: 'TEMPO', child: Text('Heavy Tempo (Up to 1,000 Kg / 1 Ton)')),
                              DropdownMenuItem(value: 'TRUCK', child: Text('Heavy Export Truck (1 Ton+)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _capacityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Payload Capacity (Kg) *',
                              prefixIcon: Icon(Icons.scale_outlined, color: AppColors.primaryCyan),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter capacity in kg' : null,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
                              onPressed: _onSaveVehicle,
                              child: const Text('Save & Register Vehicle', style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 15)),
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
