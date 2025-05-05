import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  // final Widget Function() childBuilder;

  const CustomHeader({super.key,});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Divider(color: HColors.darkgrey.withOpacity(0.5)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
