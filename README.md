# Insta - Instagram Clone App

یک اپ اندروید کامل و دقیق مثل اینستاگرام با قابلیت دانلود پست و استوری.

## ویژگی‌ها

- ✅ ورود با حساب اینستاگرام
- ✅ نمایش فید پست‌ها
- ✅ نمایش پروفایل کاربر
- ✅ لایک و کامنت روی پست‌ها
- ✅ **دانلود پست و استوری**
- ✅ جستجوی کاربران
- ✅ مشاهده استوری‌ها
- ✅ ارسال پیام‌ها
- ✅ تنظیمات پروفایل

## نیازمندی‌ها

- Flutter SDK (3.9.2+)
- Android SDK
- Dart SDK
- Android Studio یا VS Code

## نصب و راه‌اندازی

### 1. نصب وابستگی‌ها

```bash
cd insta_app
flutter pub get
```

### 2. تولید فایل‌های JSON Serializable

```bash
flutter pub run build_runner build
```

### 3. اجرای اپ

```bash
flutter run
```

### 4. بیلد APK

```bash
flutter build apk --release
```

فایل APK در مسیر `build/app/outputs/apk/release/app-release.apk` قرار می‌گیرد.

### 5. بیلد AAB (برای Google Play)

```bash
flutter build appbundle --release
```

## ساختار پروژه

```
lib/
├── main.dart                 # نقطه شروع اپ
├── models/                   # مدل‌های داده
│   ├── user_model.dart
│   ├── post_model.dart
│   ├── story_model.dart
│   ├── comment_model.dart
│   └── index.dart
├── screens/                  # صفحات اپ
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── index.dart
├── services/                 # سرویس‌های API
│   ├── instagram_service.dart
│   ├── download_service.dart
│   └── index.dart
├── providers/                # State Management
│   ├── auth_provider.dart
│   ├── feed_provider.dart
│   └── index.dart
├── widgets/                  # کامپوننت‌های قابل استفاده مجدد
│   ├── post_card.dart
│   └── index.dart
└── utils/                    # توابع کمکی
```

## وابستگی‌های اصلی

- **provider**: State Management
- **dio**: HTTP Client
- **cached_network_image**: کش تصاویر
- **image_picker**: انتخاب تصویر
- **video_player**: پخش ویدیو
- **permission_handler**: درخواست مجوزها
- **path_provider**: دسترسی به دایرکتوری‌های سیستم
- **flutter_secure_storage**: ذخیره‌سازی ایمن
- **intl**: بین‌المللی‌سازی

## مجوزهای مورد نیاز (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

## نکات مهم

### دانلود فایل‌ها

اپ فایل‌های دانلود شده را در دایرکتوری Downloads ذخیره می‌کند:
- تصاویر: `insta_username_postid_timestamp.jpg`
- ویدیوها: `insta_username_postid_timestamp.mp4`

### احراز هویت

اطلاعات ورود به صورت ایمن در `FlutterSecureStorage` ذخیره می‌شود.

### API

اپ از Instagram API استفاده می‌کند. برای استفاده بهتر، می‌توانید:
1. User-Agent را تغییر دهید
2. Proxy استفاده کنید
3. Rate limiting را مدیریت کنید

## حل مشکلات

### خطای "Build failed"

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### خطای "Permission denied"

مجوزهای مورد نیاز را در `android/app/src/main/AndroidManifest.xml` اضافه کنید.

### خطای "API error"

- اتصال اینترنت را بررسی کنید
- اطلاعات ورود را تایید کنید
- Instagram API محدودیت‌های نرخ درخواست دارد

## توسعه بیشتر

برای اضافه کردن ویژگی‌های جدید:

1. مدل‌های جدید را در `lib/models/` ایجاد کنید
2. سرویس‌های جدید را در `lib/services/` اضافه کنید
3. Providers را در `lib/providers/` به‌روزرسانی کنید
4. صفحات جدید را در `lib/screens/` بسازید

## لایسنس

این پروژه برای مقاصد آموزشی است.

## تماس و پشتیبانی

برای سؤالات و مشکلات، لطفاً issue ایجاد کنید.

---

**نسخه**: 1.0.0  
**آخرین به‌روزرسانی**: نوامبر 2025
