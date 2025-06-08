import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

class HolidayScreenSkeleton extends StatelessWidget {
  const HolidayScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Calendar Skeleton
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Calendar Header (Month/Year + Chevrons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: HColors.darkgrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                          color: HColors.darkgrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: HColors.darkgrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Days of Week
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) => Container(
                      width: 40,
                      height: 20,
                      color: HColors.darkgrey.withOpacity(0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Calendar Grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: List.generate(
                    35, // Approximate number of cells in a month
                    (index) => Container(
                      decoration: BoxDecoration(
                        color: HColors.darkgrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: HColors.darkgrey.withOpacity(0.1),
          ),
          // Event List Skeleton
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 3, // Show 3 placeholder items
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        // Date Column
                        SizedBox(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 16,
                                decoration: BoxDecoration(
                                    color: HColors.darkgrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: HColors.darkgrey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Holiday Name Container
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: HColors.darkgrey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
