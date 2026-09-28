import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../core/validators.dart';
import 'auth_scaffold.dart';

/// Placeholder: the backend has no reset endpoint yet (ARCHITECTURE §3,
/// Firebase auth comes later).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      title: 'Reset password',
      subtitle: 'Enter your email and we will send you a reset link.',
      children: [
        if (_sent)
          EmptyState(
            icon: Icons.mark_email_read_outlined,
            title: 'Check your inbox',
            message:
                'Password reset is not available yet in this build. Contact support to regain access to ${_email.text.trim()}.',
            compact: true,
          )
        else
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField.email(controller: _email, validator: Validators.email, textInputAction: TextInputAction.done),
                const SizedBox(height: AppSpacing.xl),
                AppButton.primary(label: 'Send reset link', expanded: true, size: AppButtonSize.large, onPressed: _submit),
              ],
            ),
          ),
      ],
    );
  }
}
