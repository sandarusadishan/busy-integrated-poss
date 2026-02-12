import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'creative_controls.dart';
import 'package:go_router/go_router.dart';


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
      actions: [
        // POS Button
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to POS screen
              context.push('/pos');  // Using GoRouter
            },
            icon: const Icon(Icons.point_of_sale, size: 18),
            label: const Text('POS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const CreativeControls(),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}