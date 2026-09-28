import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../core/errors.dart';
import '../../../core/validators.dart';
import '../domain/session_state.dart';
import 'auth_scaffold.dart';
import 'session_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;
  bool _seededMessage = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
      await ref
          .read(sessionControllerProvider.notifier)
          .login(email: _email.text, password: _password.text);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = describeError(e, fallback: 'Could not sign in. Check your details and try again.'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    final session = ref.watch(sessionControllerProvider);
    if (!_seededMessage && session is SignedOut && session.message != null) {
      _seededMessage = true;
      _error = session.message;
    }

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to order from vendors near you.',
      children: [
        FormErrorBanner(message: _error),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField.email(controller: _email, validator: Validators.email),
                const SizedBox(height: AppSpacing.lg),
                AppTextField.password(
                  controller: _password,
                  validator: Validators.password,
                  onSubmitted: (_) => _submit(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton.primary(
                  label: 'Sign in',
                  expanded: true,
                  size: AppButtonSize.large,
                  loading: _submitting,
                  onPressed: online ? _submit : null,
                  tooltip: online ? null : 'Sign in needs an internet connection',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("New here?", style: context.text.bodyMedium),
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ],
    );
  }
}
