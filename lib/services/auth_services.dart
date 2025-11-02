import 'package:bytesymphony/services/storage_services.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'api_services.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.login(email, password);

      if (result['success']) {
        await StorageService.saveToken(result['token']);
        await StorageService.saveEmail(email);

        // Fetch user details
        _currentUser = await ApiService.getUserDetails();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['Invalid Credential'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await StorageService.clearAll();
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is logged in
  Future<bool> checkAuth() async {
    final isLoggedIn = await StorageService.isLoggedIn();

    if (isLoggedIn) {
      _currentUser = await ApiService.getUserDetails();
      notifyListeners();
      return _currentUser != null;
    }

    return false;
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
