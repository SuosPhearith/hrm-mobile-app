import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_app/shared/color/colors.dart'; // Assuming HColors is defined here

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.black),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
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
                      print('Scanned QR Code: $scannedResult'); // Print the result
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
                      border: Border.all(color: HColors.blue, width: 4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
        title: const Text(
          'Scan Successful',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const QRScanSuccessSkeleton()
          : SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: HColors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'QR Code Scanned Successfully!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: HColors.blue.withOpacity(0.2)),
                      ),
                      child: Text(
                        widget.scannedResult,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Pop back to the previous screen with the result
                        Navigator.pop(context, widget.scannedResult);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HColors.blue,
                        foregroundColor: HColors.yellow,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}

class QRScanSuccessSkeleton extends StatelessWidget {
  const QRScanSuccessSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}