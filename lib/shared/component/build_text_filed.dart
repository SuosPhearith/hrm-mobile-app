import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool readOnly = false,
      final TextInputType? keyboardType,
    VoidCallback? onTap,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        // hintText: hint,
        // suffixIcon: Icon(Icons.calendar_today, color: HColors.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: HColors.darkgrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: HColors.darkgrey,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: HColors.darkgrey,
        ),
      ),
    );
  }