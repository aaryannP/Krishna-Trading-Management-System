import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _errorMessage;

  // Countdown timers
  int _otpCountdown = 60;
  Timer? _otpTimer;

  int _banCountdown = 172800; // 48 Hours in Seconds
  Timer? _banTimer;

  int _freezeCountdown = 86400; // 24 Hours in Seconds
  Timer? _freezeTimer;

  // Getters
  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _accessToken != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get otpCountdown => _otpCountdown;
  int get banCountdown => _banCountdown;
  int get freezeCountdown => _freezeCountdown;

  // Start OTP 60s Resend Timer
  void startOtpTimer() {
    _otpCountdown = 60;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpCountdown > 0) {
        _otpCountdown--;
        notifyListeners();
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  // Start 48-Hour Ban Countdown Timer
  void startBanTimer(int seconds) {
    _banCountdown = seconds;
    _banTimer?.cancel();
    _banTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_banCountdown > 0) {
        _banCountdown--;
        notifyListeners();
      } else {
        _banTimer?.cancel();
      }
    });
  }

  // Start 24-Hour Freeze Countdown Timer
  void startFreezeTimer(int seconds) {
    _freezeCountdown = seconds;
    _freezeTimer?.cancel();
    _freezeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_freezeCountdown > 0) {
        _freezeCountdown--;
        notifyListeners();
      } else {
        _freezeTimer?.cancel();
      }
    });
  }

  // Format seconds to HH:MM:SS
  String formatCountdown(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  // Login Action
  Future<bool> login({
    required String username,
    required String password,
    String? adminSecurityKey,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.login(
      username: username,
      password: password,
      adminSecurityKey: adminSecurityKey,
    );

    _isLoading = false;

    if (result['statusCode'] == 200) {
      final data = result['data'];
      _accessToken = data['tokens']['access'];
      _refreshToken = data['tokens']['refresh'];
      _currentUser = UserModel.fromJson(data['user']);
      notifyListeners();
      return true;
    } else {
      final data = result['data'];
      _errorMessage = data['error'] ?? data['detail'] ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  // Register Action
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.register(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
    );

    _isLoading = false;

    if (result['statusCode'] == 201) {
      startOtpTimer();
      notifyListeners();
      return true;
    } else {
      final data = result['data'];
      _errorMessage = data['error'] ?? 'Registration failed';
      notifyListeners();
      return false;
    }
  }

  // Verify OTP Action
  Future<bool> verifyOTP({
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.verifyOTP(email: email, otp: otp);

    _isLoading = false;

    if (result['statusCode'] == 200) {
      notifyListeners();
      return true;
    } else if (result['statusCode'] == 403) {
      final data = result['data'];
      final remainingSec = data['remaining_seconds'] ?? 172800;
      startBanTimer(remainingSec);
      _errorMessage = 'Banned for 48 hours due to 3 failed OTP attempts.';
      notifyListeners();
      return false;
    } else {
      final data = result['data'];
      _errorMessage = data['error'] ?? 'OTP verification failed';
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _banTimer?.cancel();
    _freezeTimer?.cancel();
    super.dispose();
  }
}
