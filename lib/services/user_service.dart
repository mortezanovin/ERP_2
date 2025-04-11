import 'package:erp_2/services/database_service.dart';
import 'package:erp_2/models/user_model.dart';
import 'dart:convert'; // برای استفاده از base64Url
import 'dart:math'; // برای استفاده از Random
import 'package:mailer/mailer.dart'; // برای ارسال ایمیل
import 'package:mailer/smtp_server.dart'; // برای تنظیمات SMTP
import '../config/email_config.dart'; // تنظیمات ایمیل

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> initialize() async {
    await _databaseService.connect();
  }

  Future<void> dispose() async {
    await _databaseService.close();
  }

  // ثبت‌نام کاربر جدید
  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String roleId,
  }) async {
    try {
      await _databaseService.execute(
        '''
        INSERT INTO users (
          username, password, email, phone, role_id
        ) VALUES (@username, @password, @email, @phone, @roleId)
        ''',
        {
          'username': username,
          'password': password,
          'email': email,
          'phone': phone,
          'roleId': roleId,
        },
      );
    } catch (e) {
      throw Exception('خطا در ثبت‌نام کاربر: $e');
    }
  }

  // دریافت لیست کاربران
  Future<List<User>> fetchUsers() async {
    try {
      final results = await _databaseService.query('SELECT * FROM users');
      return results.map((row) => User.fromMap(row)).toList();
    } catch (e) {
      throw Exception('خطا در دریافت لیست کاربران: $e');
    }
  }

  // حذف کاربر
  Future<void> deleteUser(int userId) async {
    try {
      await _databaseService.execute('DELETE FROM users WHERE id = @userId', {
        'userId': userId,
      });
    } catch (e) {
      throw Exception('خطا در حذف کاربر: $e');
    }
  }

  // اعتبارسنجی کاربر
  Future<bool> authenticateUser({
    required String username,
    required String password,
  }) async {
    try {
      final results = await _databaseService.query(
        'SELECT * FROM users WHERE username = @username AND password = @password',
        {'username': username, 'password': password},
      );
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('خطا در اعتبارسنجی کاربر: $e');
    }
  }

  // بازیابی رمز عبور
  Future<void> resetPassword(String email) async {
    try {
      // ایجاد توکن بازیابی
      final resetToken = _generateResetToken();

      // ذخیره توکن در دیتابیس
      await _databaseService.execute(
        'UPDATE users SET reset_token = @token WHERE email = @email',
        {'token': resetToken, 'email': email},
      );

      // ارسال ایمیل با لینک بازیابی
      await _sendResetEmail(email, resetToken);
    } catch (e) {
      throw Exception('خطا در بازیابی رمز عبور: $e');
    }
  }

  // ایجاد توکن بازیابی
  String _generateResetToken() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // ارسال ایمیل بازیابی
  Future<void> _sendResetEmail(String email, String resetToken) async {
    // تنظیمات سرور SMTP
    final smtpServerConfig = SmtpServer(
      EmailConfig.smtpServer,
      port: EmailConfig.port,
      username: EmailConfig.senderEmail,
      password: EmailConfig.senderPassword,
      ssl: EmailConfig.ssl,
    );

    // ایجاد پیام ایمیل
    final message =
        Message()
          ..from = Address(EmailConfig.senderEmail, 'ERP System')
          ..recipients.add(email)
          ..subject = 'بازیابی رمز عبور'
          ..html = '''
        <p>سلام،</p>
        <p>برای بازیابی رمز عبور خود، روی لینک زیر کلیک کنید:</p>
        <a href="http://your-app-url/reset-password?token=$resetToken">بازیابی رمز عبور</a>
        <p>اگر این درخواست را ارسال نکرده‌اید، لطفاً این ایمیل را نادیده بگیرید.</p>
      ''';

    try {
      // ارسال ایمیل
      await send(message, smtpServerConfig);
    } catch (e) {
      throw Exception('خطا در ارسال ایمیل: $e');
    }
  }
}
