import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with gradient overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/assets/images/pp.png'), // Replace with your background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blueGrey, // Dark overlay for readability
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and title
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo.png', // Replace with your logo image
                      height: 60, // Adjust based on your logo size
                    ),
                    SizedBox(height: 8),
                    // Khmer title
                    Text(
                      'ក្រុមប្រឹក្សាអភិវឌ្ឍន៍កម្ពុជា',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700), // Gold color
                      ),
                    ),
                    // English title
                    Text(
                      'Council for the Development of Cambodia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Center text and pagination dots
              Column(
                children: [
                  // Welcome text
                  Text(
                    'សូមស្វាគមន៍\nគម្រោងអភិវឌ្ឍន៍ ន.ស.ស.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Pagination dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD700), // Gold dot (active)
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black, // Black dot (inactive)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Bottom section: Next button and version
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    // Next button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the next screen (e.g., language selection)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF002458), // Dark blue button
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'បន្ត',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Version text
                    Text(
                      'កំណែ 1.0.1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
