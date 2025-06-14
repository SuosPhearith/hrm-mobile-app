import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/widgets/custom_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for notifications (to simulate read/unread states)
    final notifications = [
      {
        'title':
            'នាយកដ្ឋានព័ត៌មានវិទ្យា បានផ្ញើលិខិតរបាយការណ៍សម្អិតស្ដីពីស្ថានភាពសន្តិសុខបច្ចេកវិទ្យារបស់ធនាគាឌីជីថលខេមហ្សាប័រ',
        'time': 'ថ្ងៃនេះ នៅ 06:13 pm',
        'isUnread': true,
        'icon': Icons.share,
      },
      {
        'title':
            'នាយកដ្ឋានរដ្ឋបាល បានចែករំលែក ឯកសារ សេចក្ដីជូនដំណឹងស្ដីពីការឈប់សម្រាកចំនួន១ថ្ងៃ',
        'time': 'ម្សិលមិញ នៅ 03:45 pm',
        'isUnread': false,
        'icon': Icons.description,
      },
      {
        'title': 'នាយកដ្ឋានធនធានមនុស្ស បានអនុម័តសំណើឈប់សម្រាករបស់អ្នក',
        'time': 'ថ្ងៃនេះ នៅ 09:00 am',
        'isUnread': true,
        'icon': Icons.check_circle,
      },
      // Add more as needed
    ];

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'ការជូនដំណឹង',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.more_vert, color: Colors.grey),
        //     onPressed: () {
        //       // Handle more options (e.g., mark all as read)
        //     },
        //   ),
        // ],
        bottom: CustomHeader(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // New Notifications Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ថ្មីៗ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                // fontFamily: 'Khmer OS', // Replace with your Khmer font
              ),
            ),
          ),
          // New Notifications
          ...notifications
              .where((n) => n['isUnread'] == true)
              .map((notification) => _buildNotificationTile(
                    context,
                    notification['title'] as String,
                    notification['time'] as String,
                    notification['isUnread'] as bool,
                    notification['icon'] as IconData,
                  ))
              .toList(),
          // Earlier Notifications Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'មុនៗ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Earlier Notifications
          ...notifications
              .where((n) => n['isUnread'] == false)
              .map((notification) => _buildNotificationTile(
                    context,
                    notification['title'] as String,
                    notification['time'] as String,
                    notification['isUnread'] as bool,
                    notification['icon'] as IconData,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    String title,
    String time,
    bool isUnread,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to notification details or mark as read
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: HColors.darkgrey.withOpacity(0.1))
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.1),
            //     blurRadius: 4,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with Icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,

                  radius: 24,
                  // backgroundImage: AssetImage(
                  //     'lib/assets/images/logo.png',), // Replace with your asset
                  child: Image(
                    height: 36,
                    image: AssetImage('lib/assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      icon,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                // if (isUnread)
                //   const Positioned(
                //     top: -2,
                //     left: -2,
                //     child: CircleAvatar(
                //       radius: 6,
                //       backgroundColor: Colors.blue,
                //     ),
                //   ),
              ],
            ),
            const SizedBox(width: 12),
            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
                      color: Colors.black87,
                      // fontFamily: 'Khmer OS', // Replace with your Khmer font
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HColors.darkgrey,
                    ),
                  ),
                ],
              ),
            ),
            // More Options
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
              onPressed: () {
                // Show options (e.g., delete, mark as read)
              },
            ),
          ],
        ),
      ),
    );
  }
}
