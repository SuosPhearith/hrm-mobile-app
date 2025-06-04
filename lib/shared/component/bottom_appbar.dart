import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  // final Widget Function() childBuilder;

  const CustomHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          color: Colors.grey,
          height: 1.0, // Ensure the Divider's height matches
          thickness: 1.0, // Optional: Set thickness for clarity
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
