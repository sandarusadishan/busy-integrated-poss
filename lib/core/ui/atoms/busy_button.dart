import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

enum BusyButtonType {
  primary,
  secondary,
  outline,
  danger,
}

/// A custom button component that supports [BusyButtonType] for different styles.
///
/// Features:
/// - Consistent height (48.0)
/// - Border radius (8.0)
/// - Loading state indicator
/// - Disabled state handling
class BusyButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final BusyButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leadingIcon;

  const BusyButton({
    super.key,
    required this.title,
    this.onTap,
    this.type = BusyButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: switch (type) {
        BusyButtonType.primary => _buildElevatedButton(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
          ),
        BusyButtonType.secondary => _buildElevatedButton(
            backgroundColor: AppTheme.secondary,
            foregroundColor: Colors.white,
          ),
        BusyButtonType.outline => _buildOutlinedButton(),
        BusyButtonType.danger => _buildElevatedButton(
            backgroundColor: AppTheme.error,
            foregroundColor: Colors.white,
          ),
      },
    );
  }

  Widget _buildElevatedButton({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton(
      onPressed: (isDisabled || isLoading) ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: _buildContent(foregroundColor),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: (isDisabled || isLoading) ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primary,
        side: const BorderSide(color: AppTheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _buildContent(AppTheme.primary),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
