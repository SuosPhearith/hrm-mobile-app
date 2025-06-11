import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/home_provider.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/utils/help_util.dart';
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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "ប័ណ្ណសម្គាល់ខ្លួន",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              bottom: CustomHeader(),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SizedBox(
                  height: 220,
                  child: homeProvider.isLoading
                      ? CardSkeleton()
                      : FlippableCardView(homeProvider: homeProvider),
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

class FlippableCardView extends StatefulWidget {
  final HomeProvider homeProvider;

  const FlippableCardView({super.key, required this.homeProvider});

  @override
  _FlippableCardViewState createState() => _FlippableCardViewState();
}

class _FlippableCardViewState extends State<FlippableCardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final isFrontVisible = angle < math.pi / 2 || angle > 3 * math.pi / 2;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFrontVisible
                ? CardView(homeProvider: widget.homeProvider)
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: BackCardView(),
                  ),
          );
        },
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final HomeProvider homeProvider;

  const CardView({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return CustomPaint(
      painter: RotatedImagePainter(
        imagePath: 'lib/assets/images/Kbach-2.png',
        rotationAngle: 3.14159, // 180 degrees in radians
      ),
      child: Container(
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          SizedBox(height: 2),
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
                          SizedBox(height: 2),
                          Container(
                            width: 30,
                            height: 1,
                            color: Color(0xFFDDAD01),
                          ),
                        ],
                      ),
                    ),
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
                      '${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['village'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['commune'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['district'])} ,${AppLang.translate(lang: lang ?? 'kh', data: authProvider.profile?.data['user']?['province'])}  ',
                      isAddress: true,
                    ),
                  ],
                ),
              ),
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
                    child: authProvider.profile?.data['user']['avatar'] == null
                        ? const Icon(Icons.person,
                            size: 30.0, color: Colors.white)
                        : null,
                  ),
                  QrImageView(
                    data: getSafeString(
                        value:
                            authProvider.profile?.data['user']?['email'] ?? ''),
                    version: QrVersions.auto,
                    size: 56.0,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: 8),
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
                      child: Text(
                        'វិមានរាជរដ្ឋាភិបាល, វិថីសុីសុវត្ថិ, វត្តភ្នំ, ភ្នំពេញ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url = 'https://www.youtube.com';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.email,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'info@cdc.gov.kh',
                            style: TextStyle(
                              color: HColors.darkgrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+855 99 799 579',
                      style: TextStyle(fontSize: 12, color: HColors.darkgrey),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = 'www.cdc.gov.kh';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.language,
                            size: 14,
                            color: HColors.darkgrey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'www.cdc.gov.kh',
                            style: TextStyle(
                              color: HColors.darkgrey,
                              fontSize: 12,
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
  final bool _isFront = true; // Added to fix the undefined name error

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
    return GestureDetector(
      onTap: () {
        // Optional: Toggle _isFront for flip effect (can be disabled during loading)
        // setState(() {
        //   _isFront = !_isFront;
        // });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = 0.0; // No flip animation for simplicity in skeleton
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: Stack(
              children: [
                // Front Skeleton
                Positioned.fill(
                  child: _buildSkeletonCard(
                    isFront: true,
                    opacity: _opacityAnimation.value,
                  ),
                ),
                // Back Skeleton (visible when flipped)
                Positioned.fill(
                  child: Opacity(
                    opacity: _isFront ? 0.0 : _opacityAnimation.value,
                    child: _buildSkeletonCard(
                      isFront: false,
                      opacity: _opacityAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard({required bool isFront, required double opacity}) {
    return Container(
      width: double.infinity,
      height: 200,
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
      child: isFront
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonPlaceholder(width: 150, height: 20), // Name
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 200, height: 16), // Role
                const SizedBox(height: 4),
                _buildSkeletonPlaceholder(width: 30, height: 1), // Line
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 180, height: 16), // Phone
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 180, height: 16), // Email
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 200, height: 32), // Address
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildSkeletonPlaceholder(width: 72, height: 35), // Avatar
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSkeletonPlaceholder(width: 100, height: 60), // Logo
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 150, height: 20), // Khmer Text
                const SizedBox(height: 4),
                _buildSkeletonPlaceholder(
                    width: 180, height: 16), // English Text
                const SizedBox(height: 8),
                _buildSkeletonPlaceholder(width: 200, height: 32), // Address
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonPlaceholder(width: 100, height: 16), // Email
                    _buildSkeletonPlaceholder(width: 80, height: 16), // Phone
                    _buildSkeletonPlaceholder(
                        width: 100, height: 16), // Website
                  ],
                ),
              ],
            ),
    );
  }

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
