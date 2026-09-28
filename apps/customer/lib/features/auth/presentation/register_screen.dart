import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';
import '../../../core/validators.dart';
import 'auth_scaffold.dart';
import 'session_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(sessionControllerProvider.notifier).register(
            email: _email.text,
            password: _password.text,
            fullName: _name.text,
            phone: _phone.text,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = describeError(e, fallback: 'Could not create your account. Please try again.'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    return AuthScaffold(
      showBack: true,
      title: 'Create account',
      subtitle: 'A few details and you are ready to order.',
      children: [
        FormErrorBanner(message: _error),
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _name,
                  label: 'Full name',
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  validator: Validators.required('your full name'),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField.email(controller: _email, validator: Validators.email),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _phone,
                  label: 'Phone (optional)',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  textInputAction: TextInputAction.next,
                  validator: Validators.phone,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField.password(
                  controller: _password,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField.password(
                  controller: _confirm,
                  label: 'Confirm password',
                  validator: (v) => v != _password.text ? 'Passwords do not match' : null,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton.primary(
                  label: 'Create account',
                  expanded: true,
                  size: AppButtonSize.large,
                  loading: _submitting,
                  onPressed: online ? _submit : null,
                  tooltip: online ? null : 'Registration needs an internet connection',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
