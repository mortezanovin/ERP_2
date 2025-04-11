import 'package:flutter/material.dart';
import 'package:erp_2/screens/home_screen.dart';
import 'package:erp_2/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;

  final UserService _userService = UserService();

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);

      try {
        final isAuthenticated = await _userService.authenticateUser(
          username: _usernameController.text,
          password: _passwordController.text,
        );

        if (isAuthenticated) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('نام کاربری یا رمز عبور اشتباه است'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطا: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: const Text('فراموشی رمز عبور'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'ایمیل خود را وارد کنید',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await _userService.resetPassword(emailController.text);

                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ایمیل بازیابی ارسال شد')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        // ignore: use_build_context_synchronously
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطا: $e')));
                    }
                  }
                }
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('ارسال'),
            ),
          ],
        );
      },
    );
  }

  String? _validateUsername(String? value) =>
      (value == null || value.isEmpty) ? 'نام کاربری الزامیست' : null;

  String? _validatePassword(String? value) =>
      (value == null || value.length < 4) ? 'رمز عبور حداقل 4 کاراکتر' : null;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', width: 220),
                    const SizedBox(height: 30),
                    _buildCustomTextField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      label: 'نام کاربری',
                      icon: Icons.person_outline,
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 20),
                    _buildCustomTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      label: 'رمز عبور',
                      icon: Icons.lock_outline,
                      obscureText: _obscureText,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed:
                            () => setState(() => _obscureText = !_obscureText),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: const Text(
                          'رمز عبور خود را فراموش کرده‌اید؟',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login, size: 20),
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
                                  'ورود',
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
                        onPressed: _login,
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

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 1.5),
        ),
      ),
    );
  }
}
