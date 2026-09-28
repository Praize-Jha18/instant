import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/app_spacing.dart';

/// Themed text input with label above the field, helper/error text and a
/// built-in visibility toggle for passwords.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final String? initialValue;

  /// Rendered above the field (not floating).
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final AutovalidateMode? autovalidateMode;

  /// Common presets.
  static AppTextField email({
    Key? key,
    TextEditingController? controller,
    String label = 'Email',
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    TextInputAction textInputAction = TextInputAction.next,
  }) =>
      AppTextField(
        key: key,
        controller: controller,
        label: label,
        hint: 'you@example.com',
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        prefixIcon: Icons.mail_outline_rounded,
        validator: validator,
        onChanged: onChanged,
        textInputAction: textInputAction,
      );

  static AppTextField password({
    Key? key,
    TextEditingController? controller,
    String label = 'Password',
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    TextInputAction textInputAction = TextInputAction.done,
  }) =>
      AppTextField(
        key: key,
        controller: controller,
        label: label,
        obscureText: true,
        autofillHints: const [AutofillHints.password],
        prefixIcon: Icons.lock_outline_rounded,
        validator: validator,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
      );

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget? suffix = widget.suffix;
    if (suffix == null && widget.obscureText) {
      suffix = IconButton(
        tooltip: _obscured ? 'Show password' : 'Hide password',
        icon: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    } else if (suffix == null && widget.suffixIcon != null) {
      suffix = Icon(widget.suffixIcon);
    }

    final field = TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      autovalidateMode: widget.autovalidateMode,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint,
        helperText: widget.helper,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        prefix: widget.prefix,
        suffixIcon: suffix,
        counterText: '',
      ),
    );

    if (widget.label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: AppSpacing.xs),
          child: Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: widget.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        field,
      ],
    );
  }
}
