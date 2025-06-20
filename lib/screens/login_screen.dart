import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  Map<String, dynamic>? error;

  // For password visibility toggle
  bool _obscureText = true;

  @override
  void initState() {
    _emailController.text = '016331330';
    _passwordController.text = 'Hrm@1234';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer2<AuthProvider, SettingProvider>(
        builder: (context, authProvider, setting, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Expanded to take up remaining space and center its content
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        children: [
                          // Add some top padding to avoid overlap with status bar
                          SizedBox(
                              height: MediaQuery.of(context).padding.top + 20),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.phone_android_rounded,
                                size: 48,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ចូលគណនីរបស់អ្នក',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person_outline_sharp),
                              labelText: 'លេខទូរស័ព្ទ ឬ អ៊ីម៉ែល',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelText: 'ពាក្យសម្ងាត់',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          error != null
                              ? Text(
                                  AppLang.translate(
                                      lang: setting.lang ?? 'kh', data: error),
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox(),
                          // Add bottom padding to ensure content isn't too close to the button
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // Bottom button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              return;
                            }
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final AuthService authService = AuthService();
                              final res = await authService.login(
                                  username: _emailController.text,
                                  password: _passwordController.text);
                              if (context.mounted) {
                                Provider.of<AuthProvider>(context, listen: false)
                                    .setSaveToken(true, res);
                                Provider.of<AuthProvider>(context, listen: false)
                                    .handleCheckAuth();
                              }
                            } catch (e) {
                              if (e is DioException) {
                                if (context.mounted) {
                                  setState(() {
                                    error = parseErrorResponse(
                                        e.response?.data)['message'];
                                  });
                                }
                              }
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: !isLoading
                              ? Text(
                                  'ចូលប្រព័ន្ធ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
