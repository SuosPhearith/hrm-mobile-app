import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = HColors.blue, // Default color if not provided
    this.borderRadius = 25.0, // Default border radius if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: backgroundColor,
          textStyle: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
