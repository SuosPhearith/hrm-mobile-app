import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmTextColor;
  final Color? cancelTextColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'រួចរាល់',
    this.cancelText = 'បិត',
    this.confirmTextColor,
    this.cancelTextColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),

          // Buttons
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  onTap: () {
                    Navigator.pop(context, true);
                    onConfirm?.call();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        color: confirmTextColor ?? Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Colors.grey.withOpacity(0.2),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                  ),
                  onTap: () {
                    Navigator.pop(context, false);
                    onCancel?.call();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: cancelTextColor ?? Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Static method to show the dialog easily
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'រួចរាល់',
    String cancelText = 'បិត',
    Color? confirmTextColor,
    Color? cancelTextColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmTextColor: confirmTextColor,
        cancelTextColor: cancelTextColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}