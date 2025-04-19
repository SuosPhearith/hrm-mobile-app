import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/screens/select_language_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/screens/login_screen.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;
  const AuthMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, SettingProvider>(
        builder: (context, auth, setting, _) {
      if (auth.isChecking) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (!setting.isSelectingLanguage) {
        return const SelectLanguageScreen();
      }
      if (auth.isLoggedIn) {
        return child;
      }
      return const LoginScreen();
    });
  }
}
