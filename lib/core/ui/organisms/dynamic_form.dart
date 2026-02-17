import 'package:flutter/material.dart';
import '../atoms/busy_input.dart';

/// A widget that takes a JSON-like configuration and automatically renders a grid of [BusyInput] fields.
///
/// Features:
/// - Grid layout (responsive)
/// - Auto-generation of controllers (if not provided)
/// - Configuration driven
class DynamicForm extends StatefulWidget {
  final List<DynamicFieldConfig> fields;
  final Map<String, TextEditingController> controllers;
  final int crossAxisCount;
  final double childAspectRatio;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.controllers,
    this.crossAxisCount = 2,
    this.childAspectRatio = 3.0,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.fields.length,
      itemBuilder: (context, index) {
        final field = widget.fields[index];
        final controller = widget.controllers[field.key];

        if (controller == null) {
          return Center(child: Text('Missing controller for ${field.key}'));
        }

        return BusyInput(
          controller: controller,
          hintText: field.hint,
          labelText: field.label,
          isPassword: field.isPassword,
          isCurrency: field.isCurrency,
          validator: field.validator,
          readOnly: field.readOnly,
          keyboardType: field.keyboardType,
        );
      },
    );
  }
}

class DynamicFieldConfig {
  final String key;
  final String label;
  final String hint;
  final bool isPassword;
  final bool isCurrency;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;

  const DynamicFieldConfig({
    required this.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isCurrency = false,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
  });
}
