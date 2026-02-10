import 'package:flutter/material.dart';
import '../../core/theme/nomo_typography.dart';
import '../../core/theme/nomo_dimensions.dart';

/// A Bauhaus-styled text field with a bold bottom border.
class BauhausTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;

  const BauhausTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: NomoTypography.caption.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: NomoDimensions.spacing4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          style: NomoTypography.body.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
