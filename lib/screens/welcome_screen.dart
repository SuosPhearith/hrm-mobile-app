import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/pp.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Your Existing Content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/logo.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 70,
                            color: Colors.grey,
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            'ក្រុមប្រឹក្សាអភិវឌ្ឍន៍កម្ពុជា',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Council for the Development of Cambodia',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  height: 300,
                  padding: EdgeInsets.only(
                      bottom: 20), // Note: 'custom' isn't valid, see note below
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter, // Start at the bottom
                      end: Alignment.topCenter, // End at the top
                      colors: [
                        Colors.white, // 100% white at the bottom
                        Colors.white, // 100% white at the bottom
                        Colors.white10, // 0% white (transparent) at the top
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'សូមស្វាគមន៍មកកាន់',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'កម្មវិធីព័ត៌មានមន្ត្រីរាជការ ក.អ.ក',
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 24.0,
                                right: 12.0,
                                left: 12.0,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .setIsChecking(false);
                                    context.go(AppRoutes.home);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'ចូលប្រព័ន្ធ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
