import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'creative_controls.dart';

class BusyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BusyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      ),
      title: const Text(
        'Item List',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5),
      ),
      actions: const [
        CreativeControls(),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
