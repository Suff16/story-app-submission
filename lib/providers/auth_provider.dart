import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../screens/services/api_service.dart';
import '../screens/services/preferences_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesService _prefsService = PreferencesService();

  User? _user;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _isLoggedIn = await _prefsService.isLoggedIn();
      if (_isLoggedIn) {
        _user = await _prefsService.getUserSession();
      }
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _errorMessage = null;

    final response = await _apiService.register(name, email, password);

    if (response.error) {
      _errorMessage = response.message;
      return false;
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;

    final response = await _apiService.login(email, password);

    if (response.error || response.loginResult == null) {
      _errorMessage = response.message;
      return false;
    }

    _user = response.loginResult;
    await _prefsService.saveUserSession(_user!);

    await Future.delayed(const Duration(milliseconds: 100));

    _isLoggedIn = true;
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    await _prefsService.clearSession();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
