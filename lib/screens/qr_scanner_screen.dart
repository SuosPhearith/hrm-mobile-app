import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
// import 'package:mobile_app/shared/button/elevatedbutton_.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart'; // Assuming HColors is defined here

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isLoading = true;
  bool hasPermission = false;
  String? scannedResult;
  MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    setState(() {
      hasPermission = status.isGranted;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   // title: const Text(
      //   //   'ស្កេនវត្តមានចូល',
      //   //   style: TextStyle(
      //   //     fontWeight: FontWeight.w500,
      //   //     color: Colors.black,
      //   //   ),
      //   // ),
      //   centerTitle: true,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.flash_on, color: HColors.darkgrey),
      //       onPressed: () => controller.toggleTorch(),
      //     ),
      //   ],
      // ),
      body: isLoading || !hasPermission
          ? const QRScannerSkeleton()
          : Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && scannedResult == null) {
                      setState(() {
                        scannedResult = barcodes.first.rawValue;
                      });
                      // print(
                      //     'Scanned QR Code: $scannedResult'); // Print the result
                      controller.stop();
                      // Navigate to success screen instead of popping
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScanSuccessScreen(
                            scannedResult: scannedResult!,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: HColors.blue, width: 2),
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "ស្កេនវត្តមានចូល",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.transparent,
                            child: Image(
                              image: AssetImage('lib/assets/images/logo.png'),
                              height: 32,
                            ),
                          ),
                        )
                      ],
                      centerTitle: true,
                    ),
                  ),
                  bottomNavigationBar: SafeArea(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => controller.toggleTorch(),
                          child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: HColors.darkgrey.withOpacity(0.3)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.flashlight_on_outlined,
                                color: const Color.fromARGB(154, 255, 255, 255),
                                size: 32,
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            // setState(() {
                            //   controller.toggleTorch();
                            // });
                          },
                          child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: HColors.darkgrey.withOpacity(0.3)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.upload,
                                color: Color.fromARGB(154, 255, 255, 255),
                                size: 32,
                              )),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            ),
    );
  }
}

class QRScannerSkeleton extends StatelessWidget {
  const QRScannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black, // Mimics camera background
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 4),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: Theme.of(context).textTheme.titleLarge!.fontSize!,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class QRScanSuccessScreen extends StatefulWidget {
  final String scannedResult;

  const QRScanSuccessScreen({super.key, required this.scannedResult});

  @override
  State<QRScanSuccessScreen> createState() => _QRScanSuccessScreenState();
}

class _QRScanSuccessScreenState extends State<QRScanSuccessScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading (e.g., for network validation)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        bottom: CustomHeader(),
      ),
      body: isLoading
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                  Text(
                    'សូមរងចាំ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: TicketCard(),
            ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: isLoading
            ? null
            : ElevatedButton(
                onPressed: () {
                  // Pop back to the previous screen with the result
                  Navigator.pop(context, widget.scannedResult);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'រួចរាល់',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      )),
    );
  }
}

class TicketCard extends StatefulWidget {
  const TicketCard({
    super.key,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool isClick = false;
  bool isClickImage = false;

  // Future<void> _launchURL(String url) async {
  //   Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not launch $url')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;
    final date = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
    return Scaffold(
      backgroundColor: HColors.darkgrey.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 70, color: HColors.green),
                const SizedBox(height: 10),
                const Text(
                  "ស្កេនវត្តមានចូលដោយជោគជ័យ",
                  style: TextStyle(
                    fontSize: 20,
                    color: HColors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kantumruy Pro',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Header
                      Container(
                        // margin: EdgeInsets.only(
                        //     bottom: isLastItem
                        //         ? 0
                        //         : 12), // Add spacing except for last item
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            // side: const BorderSide(
                            //   width: 1,
                            //   color: Color(0xFFCBD5E1),
                            // ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: authProvider
                                          .profile?.data['user']['avatar'] !=
                                      null
                                  ? NetworkImage(
                                      '${authProvider.profile?.data['user']['avatar']['file_domain']}${authProvider.profile?.data['user']['avatar']['uri']}',
                                    )
                                  : null,
                              child: authProvider.profile?.data['user']
                                          ['avatar'] ==
                                      null
                                  ? const Icon(Icons.person,
                                      size: 30.0, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${getSafeString(safeValue: '...', value: authProvider.profile?.data['user']?['name_kh'])} (${getSafeString(safeValue: '...', value: authProvider.profile?.data['user']?['name_en'])})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    AppLang.translate(
                                        lang: lang ?? 'kh',
                                        data: authProvider.profile?.data['user']
                                            ?['user_work']?['department']),
                                    style: TextStyle(
                                        fontSize: 12, color: HColors.darkgrey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          CustomPaint(
                            painter: DashedLinePainter(),
                            child: Container(),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(
                                Icons.apartment_outlined,
                                color: HColors.darkgrey,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "អគារ A-1",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    // fontFamily: 'Kantumruy Pro',
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: HColors.darkgrey,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "រាជធានីភ្នំពេញ",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    // fontFamily: 'Kantumruy Pro',
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomPaint(
                                    painter: DashedLinePainter(),
                                    child: Container(),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "កាលបរិច្ឆេទ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: HColors.darkgrey,
                                          fontFamily: 'Kantumruy Pro',
                                        ),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontFamily: 'Kantumruy Pro',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvoiceTextWidget extends StatelessWidget {
  final String text;
  final IconData? icons;
  final VoidCallback? onTap;
  final IconData leadIcon;

  const InvoiceTextWidget({
    super.key,
    required this.text,
    this.icons,
    this.onTap,
    required this.leadIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  Icon(leadIcon, color: HColors.darkgrey),
                  const SizedBox(width: 5),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Kantumruy Pro',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        if (icons != null)
          InkWell(
            onTap: onTap,
            child: Icon(icons, size: 18),
          ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
