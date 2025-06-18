import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  bool isLoading = true;
  bool hasPermission = false;
  String? scannedResult;
  MobileScannerController controller = MobileScannerController(
    // Add iOS-specific configurations
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _forceCameraPermission(); // Use this instead
  }

  Future<void> _forceCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
        isLoading = false;
      });
      await controller.start();
    } else {
      setState(() {
        hasPermission = false;
        isLoading = false;
        errorMessage = 'Camera permission is required.';
      });
      _showPermissionDialog();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    try {
      await controller.dispose();
    } catch (e) {
      print('Error disposing controller: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle for iOS
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart scanner when app resumes
        _restartScanner();
        return;
      case AppLifecycleState.inactive:
        // Stop scanner when app becomes inactive
        _stopScanner();
        return;
    }
  }

  Future<void> _stopScanner() async {
    try {
      await controller.stop();
    } catch (e) {
      print('Error stopping scanner: $e');
    }
  }

  Future<void> _restartScanner() async {
    try {
      if (hasPermission && scannedResult == null) {
        await controller.start();
      }
    } catch (e) {
      print('Error restarting scanner: $e');
    }
  }

  Future<void> _requestCameraPermission() async {
    try {
      var status = await Permission.camera.status;

      print('Camera permission status: $status');

      if (status.isDenied) {
        status = await Permission.camera.request();
      }

      if (status.isPermanentlyDenied) {
        setState(() {
          hasPermission = false;
          isLoading = false;
          errorMessage =
              'Camera permission is permanently denied. Please enable it in Settings.';
        });
        _showPermissionDialog();
        return;
      }

      if (status.isGranted) {
        setState(() {
          hasPermission = true;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          hasPermission = false;
          isLoading = false;
          errorMessage = 'Camera permission is required to scan QR codes.';
        });
      }
    } catch (e) {
      print('Permission error: $e');
      setState(() {
        hasPermission = false;
        isLoading = false;
        errorMessage = 'Error requesting camera permission: $e';
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app needs camera permission to scan QR codes. Please enable camera permission in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Go back to previous screen
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              // Recheck permission after user returns from settings
              _requestCameraPermission();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context, listen: false).lang;

    return Scaffold(
      body: isLoading
          ? const QRScannerSkeleton()
          : !hasPermission
              ? _buildPermissionError()
              : Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        if (scannedResult != null)
                          return; // Prevent multiple scans

                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String code = barcodes.first.rawValue ?? '';
                          if (code.isNotEmpty) {
                            setState(() {
                              scannedResult = code;
                            });

                            // Stop the scanner immediately
                            controller.stop();

                            // Navigate to success screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRScanSuccessScreen(
                                  scannedResult: code,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      errorBuilder: (context, error, child) {
                        return _buildScannerError(error);
                      },
                    ),
                    // Scanner overlay
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: HColors.blue, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'Point camera at QR code',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Custom AppBar and controls
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SafeArea(
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            AppLang.translate(
                                lang: lang ?? 'kh', key: 'scan_attendence'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image:
                                      AssetImage('lib/assets/images/logo.png'),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Flashlight toggle
                              InkWell(
                                onTap: () async {
                                  try {
                                    await controller.toggleTorch();
                                  } catch (e) {
                                    print('Error toggling torch: $e');
                                  }
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: HColors.darkgrey.withOpacity(0.3),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.flashlight_on_outlined,
                                    color: Color.fromARGB(154, 255, 255, 255),
                                    size: 32,
                                  ),
                                ),
                              ),
                              // Camera switch (if needed)
                              InkWell(
                                onTap: () async {
                                  try {
                                    await controller.switchCamera();
                                  } catch (e) {
                                    print('Error switching camera: $e');
                                  }
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: HColors.darkgrey.withOpacity(0.3),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.switch_camera,
                                    color: Color.fromARGB(154, 255, 255, 255),
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPermissionError() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 20),
            const Text(
              'Camera Permission Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                errorMessage ??
                    'Please grant camera permission to scan QR codes',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
                _requestCameraPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HColors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Open Settings'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerError(MobileScannerException error) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Scanner Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Error: ${error.errorCode}\n${error.errorDetails?.message ?? 'Unknown error occurred'}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _requestCameraPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HColors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep your existing QRScannerSkeleton, QRScanSuccessScreen, TicketCard, etc. classes unchanged
class QRScannerSkeleton extends StatelessWidget {
  const QRScannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
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
        const Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Initializing Camera...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
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
