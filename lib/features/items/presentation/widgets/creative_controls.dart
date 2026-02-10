import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../providers/view_mode_provider.dart';

class CreativeControls extends ConsumerWidget {
  const CreativeControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(viewModeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Row(
      children: [
        // View Mode Toggle
        Container(
          height: 32,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              _toggleIcon(
                icon: Icons.list,
                isActive: currentMode == ViewMode.normal,
                onTap: () => ref
                    .read(viewModeProvider.notifier)
                    .setMode(ViewMode.normal),
              ),
              _toggleIcon(
                icon: Icons.grid_view,
                isActive: currentMode == ViewMode.visual,
                onTap: () => ref
                    .read(viewModeProvider.notifier)
                    .setMode(ViewMode.visual),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Theme Toggle (Sun/Moon)
        GestureDetector(
          onTap: () {
            ref
                .read(themeModeProvider.notifier)
                .setMode(isDark ? ThemeMode.light : ThemeMode.dark);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF333333) : const Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.nights_stay : Icons.wb_sunny,
                  size: 18,
                  color: isDark ? Colors.white : const Color(0xFFE65100),
                ),
                const SizedBox(width: 6),
                Text(
                  isDark ? "Dark" : "Light",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleIcon(
      {required IconData icon,
      required bool isActive,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
