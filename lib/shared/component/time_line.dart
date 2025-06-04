import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Define timeline entries
    final timelineEntries = [
      {
        'title': 'Order Placed',
        'description': 'We have received your order',
        'isFirst': true,
        'isLast': false,
      },
      {
        'title': 'Order Confirmed',
        'description': 'We have confirmed your order',
        'isFirst': false,
        'isLast': false,
      },
      {
        'title': 'Order Shipped',
        'description': 'We have shipped your order',
        'isFirst': false,
        'isLast': true,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: timelineEntries.length,
      itemBuilder: (context, index) {
        final entry = timelineEntries[index];
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: entry['isFirst'] as bool,
          isLast: entry['isLast'] as bool,
          indicatorStyle: IndicatorStyle(
            width: 30,
            color: Colors.white,
            iconStyle: IconStyle(
              iconData: Icons.check,
              color: entry['isFirst'] as bool ? Colors.black : Colors.purple,
            ),
          ),
          beforeLineStyle: const LineStyle(
            color: Colors.purple,
            thickness: 3,
          ),
          afterLineStyle: const LineStyle(
            color: Colors.purple,
            thickness: 3,
          ),
          endChild: _buildTimelineCard(
            title: entry['title'] as String,
            description: entry['description'] as String,
          ),
        );
      },
    );
  }

  Widget _buildTimelineCard({
    required String title,
    required String description,
  }) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15), // Semi-transparent background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.9), width: 1),
          ),
          child: Stack(children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
