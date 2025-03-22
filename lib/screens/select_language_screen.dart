import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.language,
                    size: 48,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ជ្រើសរើសភាសា',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Choose your language',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        await provider.handleSetLanguage('kh');
                      } catch (e) {
                        if (context.mounted) {
                          showErrorDialog(
                              context, "មានបញ្ហាកើតឡើងក្នុងការជ្រើសរើសភាសា");
                        }
                      }
                    },
                    child: Container(
                      width: 350,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12, // Shadow color
                            spreadRadius: 2, // How much the shadow spreads
                            blurRadius: 5, // How blurry the shadow is
                            offset: Offset(0, 2), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text('🇰🇭',
                                    style: TextStyle(fontSize: 20))),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'ភាសាខ្មែរ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await provider.handleSetLanguage('en');
                      } catch (e) {
                        if (context.mounted) {
                          showErrorDialog(
                              context, "មានបញ្ហាកើតឡើងក្នុងការជ្រើសរើសភាសា");
                        }
                      }
                    },
                    child: Container(
                      width: 350,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text('🇺🇸',
                                    style: TextStyle(fontSize: 20))),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'English',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
