import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Login Request
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String? adminSecurityKey,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login/');
    final body = {
      'username': username,
      'email': username,
      'password': password,
      if (adminSecurityKey != null && adminSecurityKey.isNotEmpty)
        'admin_security_key': adminSecurityKey,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Failed to connect to backend server: $e'},
      };
    }
  }

  // Registration Request
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register/');
    final body = {
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword ?? password,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': phone,
      'phone_number': phone,
      'role': role,
      'admin_passkey': 'PARM81492004',
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Failed to connect to backend server: $e'},
      };
    }
  }

  // Add Person / Internal Staff Request (Admin Suite)
  static Future<Map<String, dynamic>> addPerson({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/users/add-person/');
    final body = {
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': password,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': phone,
      'phone_number': phone,
      'role': role,
      'admin_passkey': 'PARM81492004',
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Failed to connect to backend server: $e'},
      };
    }
  }

  // Verify OTP Request
  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp/');
    final body = {
      'email': email,
      'otp': otp,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Failed to connect to backend server: $e'},
      };
    }
  }

  // Fetch All Users Count & Breakdown
  static Future<Map<String, dynamic>> getUsersList([String? token]) async {
    final url = Uri.parse('$baseUrl/users/');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      final data = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'error': 'Failed to connect to backend server: $e'},
      };
    }
  }
  static Future<Map<String, dynamic>> getAssets() async {
    final url = Uri.parse('$baseUrl/assets/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Create New Asset
  static Future<Map<String, dynamic>> addAsset(Map<String, dynamic> assetData) async {
    final url = Uri.parse('$baseUrl/assets/');
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(assetData));
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Fetch Asset Dashboard Metrics
  static Future<Map<String, dynamic>> getAssetDashboard() async {
    final url = Uri.parse('$baseUrl/assets/dashboard/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Fetch Asset Assignments
  static Future<Map<String, dynamic>> getAssetAssignments() async {
    final url = Uri.parse('$baseUrl/assets/assignments/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Assign Asset to Person
  static Future<Map<String, dynamic>> assignAsset(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/assets/assignments/');
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Fetch Asset Maintenance Logs
  static Future<Map<String, dynamic>> getAssetMaintenance() async {
    final url = Uri.parse('$baseUrl/assets/maintenance/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }

  // Fetch Fleet Dashboard Data
  static Future<Map<String, dynamic>> getFleetDashboard() async {
    final url = Uri.parse('$baseUrl/fleet/dashboard/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      return {'statusCode': response.statusCode, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {'statusCode': 500, 'data': {'error': 'Failed to connect: $e'}};
    }
  }
}
