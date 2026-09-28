import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/redirect.dart';
import '../../../core/errors.dart';
import '../data/auth_controller.dart';
import '../domain/validators.dart';
import 'auth_scaffold.dart';

/// Widget keys used by tests.
abstract final class LoginKeys {
  static const email = Key('login.email');
  static const password = Key('login.password');
  static const submit = Key('login.submit');
  static const error = Key('login.error');
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).login(email: _email.text, password: _password.text);
      // Router redirect takes over.
    } on NotARiderException catch (e) {
      setState(() => _error = e.toString());
    } catch (e) {
      setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to start delivering.',
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField.email(key: LoginKeys.email, controller: _email, validator: Validators.email),
              AppSpacing.gapLg,
              AppTextField.password(
                key: LoginKeys.password,
                controller: _password,
                validator: Validators.password,
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                AppSpacing.gapLg,
                _ErrorBanner(key: LoginKeys.error, message: _error!),
              ],
              AppSpacing.gapXl,
              AppButton.primary(
                key: LoginKeys.submit,
                label: 'Sign in',
                expanded: true,
                size: AppButtonSize.large,
                loading: _busy,
                onPressed: online ? _submit : null,
                tooltip: online ? null : 'Signing in needs a connection',
              ),
              AppSpacing.gapLg,
              AppButton.ghost(
                label: 'New rider? Create an account',
                onPressed: _busy ? null : () => context.go(Routes.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final s = context.semanticColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: s.dangerContainer, borderRadius: AppRadius.smAll),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: s.onDangerContainer, size: 20),
          AppSpacing.gapSm,
          Expanded(child: Text(message, style: context.text.bodyMedium?.copyWith(color: s.onDangerContainer))),
        ],
      ),
    );
  }
}
