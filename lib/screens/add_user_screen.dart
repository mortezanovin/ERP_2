import 'package:flutter/material.dart';
import 'package:erp_2/services/user_service.dart'; // سرویس مدیریت کاربران

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  AddUserScreenState createState() => AddUserScreenState();
}

class AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleIdController = TextEditingController();

  bool _isLoading = false;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _userService.initialize();
  }

  @override
  void dispose() {
    _userService.dispose();
    super.dispose();
  }

  // متد ثبت‌نام کاربر
  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus(); // بستن کیبورد
      setState(() => _isLoading = true); // نمایش لوادینگ

      try {
        await _userService.register(
          username: _usernameController.text,
          password: _passwordController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          roleId: _roleIdController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کاربر با موفقیت اضافه شد')),
          );
          Navigator.pop(context); // بازگشت به صفحه قبل
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطا: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false); // پنهان کردن لوادینگ
        }
      }
    }
  }

  String? _validateField(String? value, String fieldName) =>
      (value == null || value.isEmpty) ? '$fieldName الزامیست' : null;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('افزودن کاربر جدید'),
          backgroundColor: Colors.blue[800],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400, // عرض فرم را کاهش داده‌ایم
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(15),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // فیلد نام کاربری
                    _buildCustomTextField(
                      controller: _usernameController,
                      labelText: 'نام کاربری',
                      icon: Icons.person_outline,
                      validator: (value) => _validateField(value, 'نام کاربری'),
                    ),
                    const SizedBox(height: 20),

                    // فیلد رمز عبور
                    _buildCustomTextField(
                      controller: _passwordController,
                      labelText: 'رمز عبور',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) => _validateField(value, 'رمز عبور'),
                    ),
                    const SizedBox(height: 20),

                    // فیلد ایمیل
                    _buildCustomTextField(
                      controller: _emailController,
                      labelText: 'ایمیل',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateField(value, 'ایمیل'),
                    ),
                    const SizedBox(height: 20),

                    // فیلد شماره تماس
                    _buildCustomTextField(
                      controller: _phoneController,
                      labelText: 'شماره تماس',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validateField(value, 'شماره تماس'),
                    ),
                    const SizedBox(height: 20),

                    // فیلد شناسه نقش
                    _buildCustomTextField(
                      controller: _roleIdController,
                      labelText: 'شناسه نقش',
                      icon: Icons.tag_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateField(value, 'شناسه نقش'),
                    ),
                    const SizedBox(height: 30),

                    // دکمه ثبت‌نام
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 20),
                        label:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'ثبت کاربر',
                                  style: TextStyle(fontSize: 16),
                                ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          elevation: 3,
                        ),
                        onPressed: _registerUser,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // متد ساخت فیلدهای سفارشی
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
