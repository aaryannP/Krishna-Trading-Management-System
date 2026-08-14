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
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phone,
      'role': role,
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
  static Future<Map<String, dynamic>> getUsersList(String token) async {
    final url = Uri.parse('$baseUrl/users/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
}
