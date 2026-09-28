import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import 'auth_layout.dart';

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
    if (_busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(sessionProvider.notifier).login(email: _email.text, password: _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final semantic = context.semanticColors;
    return AuthLayout(
      title: 'Sign in',
      subtitle: 'Vendor owners, staff and platform admins.',
      child: AutofillGroup(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (session.expired)
                _Notice(text: 'Your session expired. Please sign in again.', color: semantic.warningContainer, fg: semantic.onWarningContainer),
              if (session.restoreError != null)
                _Notice(
                    text: 'Could not restore your session: ${errorMessage(session.restoreError)}',
                    color: semantic.warningContainer,
                    fg: semantic.onWarningContainer),
              AppTextField.email(controller: _email, validator: emailValidator),
              AppSpacing.gapLg,
              AppTextField.password(controller: _password, validator: passwordValidator, onSubmitted: (_) => _submit()),
              if (_error != null) ...[
                AppSpacing.gapMd,
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              AppSpacing.gapXl,
              AppButton.primary(label: 'Sign in', onPressed: _submit, loading: _busy, expanded: true, size: AppButtonSize.large),
              AppSpacing.gapMd,
              AppButton.ghost(label: 'Register as a vendor', onPressed: () => context.go('/register'), expanded: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.color, required this.fg});
  final String text;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: color, borderRadius: AppRadius.smAll),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: fg)),
      );
}
