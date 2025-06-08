import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _UserProfileHeaderSkeleton(),
          const SizedBox(height: 10),
          _DailyMonthlyViewSkeleton(),
          _MenuGridSkeleton(),
          _RequestSectionSkeleton(),
        ],
      ),
    );
  }
}

class _UserProfileHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HColors.darkgrey.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height:
                            Theme.of(context).textTheme.bodyLarge!.fontSize!,
                        color: HColors.darkgrey.withOpacity(0.1),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height:
                            Theme.of(context).textTheme.bodySmall!.fontSize!,
                        color: HColors.darkgrey.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyMonthlyViewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 220,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(13.0),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height:
                              Theme.of(context).textTheme.bodyLarge!.fontSize!,
                          color: HColors.darkgrey.withOpacity(0.1),
                        ),
                        Container(
                          width: 80.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                            color: HColors.darkgrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HColors.darkgrey.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            children: [
                              _CheckInOutCardSkeleton(),
                              const SizedBox(height: 12.0),
                              _CheckInOutCardSkeleton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HColors.darkgrey.withOpacity(0.1),
                  ),
                ),
                SizedBox(width: 4.0),
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HColors.darkgrey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckInOutCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: HColors.darkgrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: Theme.of(context).textTheme.bodySmall!.fontSize!,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: Theme.of(context).textTheme.bodySmall!.fontSize!,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGridSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: const BoxDecoration(color: Colors.white),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 142 / 100,
        padding: EdgeInsets.zero,
        children: List.generate(9, (index) {
          return Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HColors.darkgrey.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 16.0,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _RequestSectionSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(3, (index) {
            return _RequestCardSkeleton();
          }),
        ],
      ),
    );
  }
}

class _RequestCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: Theme.of(context).textTheme.bodyMedium!.fontSize!,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height:
                            Theme.of(context).textTheme.bodySmall!.fontSize!,
                        color: HColors.darkgrey.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 60.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: HColors.darkgrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: Theme.of(context).textTheme.bodySmall!.fontSize!,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: HColors.darkgrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }
}
