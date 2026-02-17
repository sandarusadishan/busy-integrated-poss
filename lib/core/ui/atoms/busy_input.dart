import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_theme.dart';

/// A reusable text field component.
///
/// Features:
/// - Custom styling matching AppTheme
/// - Currency Formatting (right-aligned)
/// - Prefix/Suffix icons
/// - Built-in validation logic
class BusyInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final bool isCurrency;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int? maxLines;

  const BusyInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isCurrency = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTheme.labelLarge,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: isCurrency
              ? const TextInputType.numberWithOptions(decimal: true)
              : keyboardType,
          readOnly: readOnly,
          maxLines: isPassword ? 1 : maxLines,
          textAlign: isCurrency ? TextAlign.end : TextAlign.start,
          inputFormatters: isCurrency
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ]
              : null,
          onChanged: (value) {
            if (isCurrency) {
              _formatCurrency(value);
            }
            onChanged?.call(value);
          },
          validator: validator,
          style: AppTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTheme.bodyMedium,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _formatCurrency(String value) {
    // Basic currency formatting logic can be enhanced here
    // For now, we rely on inputFormatters to restrict input
    // In a real app, you might want check for valid double parsing
    // and format it with commas as the user types, but that's complex
    // for a simple input.
  }
}
