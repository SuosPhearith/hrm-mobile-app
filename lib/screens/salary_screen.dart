import 'package:flutter/material.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFCBD5E1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0C0C0C0D),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://file-v4-api.uat.camcyber.com/upload/file/49892209-72de-401d-9722-73f5501344d0"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                'ខួច គឿន',
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 16,
                                  fontFamily: 'Kantumruy Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.25,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '(KHOUCH KOEUN)',
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                  fontFamily: 'Kantumruy Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Position
                        Text(
                          'អនុប្រធានាយកដ្ឋាន | អគ្គលេខាធិការដ្ឋាន នៃ ក.អ.ក.',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Kantumruy Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.67,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Info Row - Responsive Layout
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // If screen is narrow, stack vertically
                            if (constraints.maxWidth < 300) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoItem(Icons.work_outline,
                                      'មន្ត្រីក្របខណ្ឌ (ក.១.៤)'),
                                  const SizedBox(height: 2),
                                  _buildInfoItem(
                                      Icons.badge_outlined, 'CDC-0003'),
                                  const SizedBox(height: 2),
                                  _buildInfoItem(
                                      Icons.phone_outlined, '0965416704'),
                                ],
                              );
                            }
                            // Otherwise use horizontal layout with wrapping
                            return Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildInfoItem(Icons.work_outline,
                                    'មន្ត្រីក្របខណ្ឌ (ក.១.៤)'),
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 12,
                                    fontFamily: 'Kantumruy Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                                _buildInfoItem(
                                    Icons.badge_outlined, 'CDC-0003'),
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 12,
                                    fontFamily: 'Kantumruy Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                                _buildInfoItem(
                                    Icons.phone_outlined, '0965416704'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align content to the start
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items at the top
              children: [
                // First child: Row with an image
                Row(
                  children: [
                    Column(
                      children: [
                        Image.network(
                          "https://file-v4-api.uat.camcyber.com/upload/file/49892209-72de-401d-9722-73f5501344d0",
                          width:
                              18, // Fixed size for the image, but can be adjusted
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 10), // Add spacing between the image and text
                // Second child: Column with date, duration, and label
                Expanded(
                  // Use Expanded to make the column take available space
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Space out the texts
                        children: [
                          Text(
                            "20-01-2025 ដល់ 23-01-2025",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "4 ថ្ងៃ",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4), // Add spacing between rows
                      Text(
                        "កាលបរិច្ឆេទ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Kantumruy Pro',
            fontWeight: FontWeight.w400,
            height: 1.67,
          ),
        ),
      ],
    );
  }
}
