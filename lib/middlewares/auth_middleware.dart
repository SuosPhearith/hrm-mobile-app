import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/screens/select_language_screen.dart';
import 'package:mobile_app/shared/color/colors.dart';
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
          backgroundColor: HColors.blue,
          body: Stack(
            children: [
              Positioned(
                left: -50,
                top: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/f.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('lib/assets/images/logo.png'),
                        ),
                      ),
                    ),
                    // EText(
                    //   text: "ក្រុមប្រឹក្សារអភិវឌ្ឍកម្ពុជា",
                    //   size: EFontSize.header,
                    //   color: HColors.yellow,
                    // ),
                  ],
                ),
              ),
              Positioned(
                right: -50,
                bottom: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/f.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
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
