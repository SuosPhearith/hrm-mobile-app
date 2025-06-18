import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/home_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          final lang =
              Provider.of<SettingProvider>(context, listen: false).lang;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLang.translate(lang: lang ?? 'kh', key: 'card'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              bottom: CustomHeader(),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      showConfirmDialog(
                          context,
                          AppLang.translate(
                              lang: lang ?? 'kh', key: 'developing'),
                         AppLang.translate(
                              lang: lang ?? 'kh', key: 'developing'),
                          DialogType.primary,
                          () {});
                    },
                    icon: Icon(
                      Icons.download_outlined,
                      color: HColors.darkgrey,
                      size: 22,
                    ),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: homeProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CardSkeleton(),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          CardView(homeProvider: homeProvider),
                          const SizedBox(
                              height: 16), // Add spacing between cards
                          const BackCardView(),
                          const SizedBox(height: 16), // Add bottom padding
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class RotatedImagePainter extends CustomPainter {
  final String imagePath;
  final double rotationAngle;

  RotatedImagePainter({required this.imagePath, required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotationAngle);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CardView extends StatelessWidget {
  final HomeProvider homeProvider;

  const CardView({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFCBD5E1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        image: DecorationImage(
          image: AssetImage('lib/assets/images/Kbach-2.png'),
          fit: BoxFit.contain,
          opacity: 0.3,
          alignment: Alignment.centerLeft,
        ),
      ),
      child: Column(
        children: [
          // Main content row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - User information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header section
                      Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getSafeString(
                                  safeValue: '...',
                                  value: authProvider.profile?.data['user']
                                      ?['name_kh']),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: HColors.blue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            SizedBox(
                              width: 220,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    "${AppLang.translate(data: authProvider.profile?.data['user']['roles'][0]['department'], lang: lang ?? 'kh')} | ${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['user_work']?['staff_type'])}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              width: 30,
                              height: 1,
                              color: Color(0xFFDDAD01),
                            ),
                          ],
                        ),
                      ),
                      // Contact information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContactRow(
                            Icons.phone_android_sharp,
                            '${getSafeString(value: authProvider.profile?.data['user']?['phone_number'])} ',
                          ),
                          const SizedBox(height: 4),
                          _buildContactRow(
                            Icons.email,
                            '${getSafeString(value: authProvider.profile?.data['user']?['email'])} ',
                          ),
                          const SizedBox(height: 4),
                          _buildContactRow(
                            Icons.location_on,
                            '${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['village'])} ${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['commune'])} ${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['district'])} ${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['province'])} ',
                            isAddress: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side - Avatar and QR
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          authProvider.profile?.data['user']['avatar'] != null
                              ? NetworkImage(
                                  '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                                )
                              : null,
                      child:
                          authProvider.profile?.data['user']['avatar'] == null
                              ? const Icon(Icons.person,
                                  size: 30.0, color: Colors.white)
                              : null,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 56.0,
                      height: 56.0,
                      child: QrImageView(
                        data: getSafeString(
                            value: authProvider.profile?.data['user']
                                    ?['email'] ??
                                ''),
                        version: QrVersions.auto,
                        size: 56.0,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text,
      {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 14,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 210,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: isAddress ? 2 : 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackCardView extends StatelessWidget {
  const BackCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFCBD5E1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          // Background decorative images
          Positioned(
            left: -30,
            top: -30,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/f.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -30,
            bottom: -30,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/f.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Container(
                  height: 60,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('lib/assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Organization names
                Column(
                  children: [
                    Text(
                      "ក្រុមប្រឹក្សារអភិវឌ្ឍកម្ពុជា",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Council for the Development of Cambodia",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Address
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.location_on,
                        size: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      // Use Flexible to prevent overflow
                      child: Text(
                        AppLang.translate(
                            lang: lang ?? 'kh',
                            key:
                                'Government Palace, Sisowath Street, Wat Phnom'),
                        style: const TextStyle(
                          // color: Color(0xFF0F172A),
                          fontSize: 12,

                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            TextAlign.center, // Center text within the Flexible
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Contact information row
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8.0, // Horizontal spacing between items
                  runSpacing: 8.0, // Vertical spacing between wrapped lines
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url =
                            'mailto:info@cdc.gov.kh'; // Use mailto for email
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch email')),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Prevent Row from taking full width
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'info@cdc.gov.kh',
                              overflow:
                                  TextOverflow.ellipsis, // Handle overflow
                              style: TextStyle(
                                color: HColors.darkgrey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = 'tel:+85599799579'; // Use tel for phone
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch phone')),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '+855 99 799 579',
                            style: TextStyle(
                              fontSize: 10,
                              color: HColors.darkgrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url =
                            'https://www.cdc.gov.kh'; // Fix URL with https
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Consistent alignment
                        children: [
                          Icon(
                            Icons.language,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'www.cdc.gov.kh',
                              overflow:
                                  TextOverflow.ellipsis, // Handle overflow
                              style: TextStyle(
                                color: HColors.darkgrey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Skeleton Widget
class CardSkeleton extends StatefulWidget {
  const CardSkeleton({super.key});

  @override
  _CardSkeletonState createState() => _CardSkeletonState();
}

class _CardSkeletonState extends State<CardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  // final bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Front card skeleton
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: HColors.darkgrey.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCBD5E1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSkeletonPlaceholder(width: 150, height: 18),
                          const SizedBox(height: 6),
                          _buildSkeletonPlaceholder(width: 200, height: 14),
                          const SizedBox(height: 4),
                          _buildSkeletonPlaceholder(width: 30, height: 1),
                          const SizedBox(height: 6),
                          _buildSkeletonPlaceholder(width: 160, height: 14),
                          const SizedBox(height: 4),
                          _buildSkeletonPlaceholder(width: 160, height: 14),
                          const SizedBox(height: 4),
                          _buildSkeletonPlaceholder(width: 180, height: 28),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSkeletonPlaceholder(width: 72, height: 72),
                        const SizedBox(height: 8),
                        _buildSkeletonPlaceholder(width: 56, height: 56),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Back card skeleton
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: HColors.darkgrey.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCBD5E1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSkeletonPlaceholder(width: 100, height: 50),
                  const SizedBox(height: 8),
                  _buildSkeletonPlaceholder(width: 150, height: 18),
                  const SizedBox(height: 4),
                  _buildSkeletonPlaceholder(width: 180, height: 14),
                  const SizedBox(height: 8),
                  _buildSkeletonPlaceholder(width: 200, height: 28),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSkeletonPlaceholder(width: 80, height: 14),
                      _buildSkeletonPlaceholder(width: 70, height: 14),
                      _buildSkeletonPlaceholder(width: 80, height: 14),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildSkeletonCard({required bool isFront, required double opacity}) {
  //   return AnimatedBuilder(
  //     animation: _controller,
  //     builder: (context, child) {
  //       return Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(16),
  //         clipBehavior: Clip.antiAlias,
  //         decoration: ShapeDecoration(
  //           color: HColors.darkgrey.withOpacity(0.1),
  //           shape: RoundedRectangleBorder(
  //             side: const BorderSide(
  //               width: 1,
  //               color: Color(0xFFCBD5E1),
  //             ),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //         ),
  //         child: isFront
  //             ? IntrinsicHeight(
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           _buildSkeletonPlaceholder(width: 150, height: 18), // Name
  //                           const SizedBox(height: 6),
  //                           _buildSkeletonPlaceholder(width: 200, height: 14), // Role
  //                           const SizedBox(height: 4),
  //                           _buildSkeletonPlaceholder(width: 30, height: 1), // Line
  //                           const SizedBox(height: 6),
  //                           _buildSkeletonPlaceholder(width: 160, height: 14), // Phone
  //                           const SizedBox(height: 4),
  //                           _buildSkeletonPlaceholder(width: 160, height: 14), // Email
  //                           const SizedBox(height: 4),
  //                           _buildSkeletonPlaceholder(width: 180, height: 28), // Address
  //                         ],
  //                       ),
  //                     ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         _buildSkeletonPlaceholder(width: 72, height: 72), // Avatar
  //                         const SizedBox(height: 8),
  //                         _buildSkeletonPlaceholder(width: 56, height: 56), // QR
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             : Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   _buildSkeletonPlaceholder(width: 100, height: 50), // Logo
  //                   const SizedBox(height: 8),
  //                   _buildSkeletonPlaceholder(width: 150, height: 18), // Khmer Text
  //                   const SizedBox(height: 4),
  //                   _buildSkeletonPlaceholder(
  //                       width: 180, height: 14), // English Text
  //                   const SizedBox(height: 8),
  //                   _buildSkeletonPlaceholder(width: 200, height: 28), // Address
  //                   const SizedBox(height: 8),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       _buildSkeletonPlaceholder(width: 80, height: 14), // Email
  //                       _buildSkeletonPlaceholder(width: 70, height: 14), // Phone
  //                       _buildSkeletonPlaceholder(
  //                           width: 80, height: 14), // Website
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //       );
  //     },
  //   );
  // }

  Widget _buildSkeletonPlaceholder(
      {required double width, required double height}) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: Duration(milliseconds: 500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: HColors.darkgrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
