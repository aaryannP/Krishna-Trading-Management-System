import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/admin_sidebar_navigation.dart';

class VehicleDocumentsScreen extends StatefulWidget {
  const VehicleDocumentsScreen({super.key});

  @override
  State<VehicleDocumentsScreen> createState() => _VehicleDocumentsScreenState();
}

class _VehicleDocumentsScreenState extends State<VehicleDocumentsScreen> {
  List<dynamic> _docs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocs();
  }

  Future<void> _fetchDocs() async {
    setState(() => _isLoading = true);
    final response = await ApiService.getVehicleDocuments();
    if (mounted) {
      if (response['statusCode'] == 200 && response['data'] != null) {
        setState(() {
          _docs = response['data']['documents'] ?? [];
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
              title: const Text('PUC & Insurance Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: AdminSidebarNavigation(currentRoute: '/admin/fleet/documents')) : null,
      body: Row(
        children: [
          if (isDesktop) const AdminSidebarNavigation(currentRoute: '/admin/fleet/documents'),
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
                          Text('PUC, Insurance & Fitness Alert Center', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('Monitor vehicle document expirations, renewal alerts, and compliance status.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryCyan),
                        tooltip: 'Refresh Documents',
                        onPressed: _fetchDocs,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: _isLoading
                        ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primaryCyan)))
                        : _docs.isEmpty
                            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No vehicle compliance documents in database yet.', style: TextStyle(color: AppColors.textSecondary))))
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(AppColors.background),
                                  columns: const [
                                    DataColumn(label: Text('REGISTRATION NO', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('VEHICLE TYPE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('PUC EXPIRY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('INSURANCE EXPIRY', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                    DataColumn(label: Text('COMPLIANCE', style: TextStyle(color: AppColors.textDisabled, fontSize: 11))),
                                  ],
                                  rows: _docs.map((d) {
                                    final regNo = (d['registration_no'] ?? 'GJ-01-XX').toString();
                                    final type = (d['vehicle_type'] ?? 'Vehicle').toString();
                                    final puc = (d['puc_expiry'] ?? 'N/A').toString();
                                    final ins = (d['insurance_expiry'] ?? 'N/A').toString();
                                    final statusStr = (d['status'] ?? 'Compliant 🟢').toString();

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(regNo, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryCyan))),
                                        DataCell(Text(type, style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text(puc, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(Text(ins, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: AppColors.emeraldGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                                            child: Text(statusStr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.emeraldGreen)),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
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
