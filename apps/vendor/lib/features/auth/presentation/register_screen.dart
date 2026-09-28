import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import '../../vendor/presentation/vendor_profile_form.dart';
import 'auth_layout.dart';

/// Two steps: account (email/password/name/phone/business name) then the
/// store profile (address with map pin, delivery fees, opening hours).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _business = TextEditingController();
  int _step = 0;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_fullName, _email, _phone, _password, _business]) {
      c.dispose();
    }
    super.dispose();
  }

  void _next() {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _step = 1);
  }

  Future<void> _submit(VendorInput profile) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final warning = await ref.read(sessionProvider.notifier).registerVendor(
            email: _email.text,
            password: _password.text,
            fullName: _fullName.text,
            phone: _phone.text,
            businessName: _business.text,
            profile: profile,
          );
      if (warning != null && mounted) {
        showSnack(context, 'Account created. Profile could not be saved yet: $warning', error: true);
      }
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    final theme = Theme.of(context);
    if (_step == 1) {
      return AuthLayout(
        title: 'Set up ${_business.text.trim()}',
        subtitle: 'Step 2 of 2 · Where you are and how you deliver. You can change all of this later.',
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VendorProfileForm(
              showName: false,
              sections: const [
                VendorFormSection.basics,
                VendorFormSection.address,
                VendorFormSection.deliveryFee,
                VendorFormSection.hours,
              ],
              submitLabel: 'Create my store',
              busy: _busy,
              onSubmit: _submit,
            ),
            if (_error != null) ...[
              AppSpacing.gapMd,
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            AppSpacing.gapSm,
            AppButton.ghost(label: 'Back', onPressed: _busy ? null : () => setState(() => _step = 0)),
          ],
        ),
      );
    }
    return AuthLayout(
      title: 'Register your store',
      subtitle: 'Step 1 of 2 · Owner account. Registration needs an internet connection.',
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                  controller: _business,
                  label: 'Business name',
                  prefixIcon: Icons.storefront_outlined,
                  validator: (v) => requiredField(v, 'Business name'),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              AppSpacing.gapLg,
              AppTextField(
                  controller: _fullName,
                  label: 'Your full name',
                  prefixIcon: Icons.person_outline,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) => (v ?? '').trim().length < 2 ? 'Enter your name' : null,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words),
              AppSpacing.gapLg,
              AppTextField.email(controller: _email, validator: emailValidator),
              AppSpacing.gapLg,
              AppTextField(
                  controller: _phone,
                  label: 'Phone (optional)',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  textInputAction: TextInputAction.next),
              AppSpacing.gapLg,
              AppTextField.password(
                  controller: _password, validator: passwordValidator, textInputAction: TextInputAction.done, onSubmitted: (_) => _next()),
              AppSpacing.gapXl,
              AppButton.primary(
                label: 'Continue',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: online ? _next : null,
                tooltip: 'You are offline',
                expanded: true,
                size: AppButtonSize.large,
              ),
              AppSpacing.gapMd,
              AppButton.ghost(label: 'I already have an account', onPressed: () => context.go('/login'), expanded: true),
            ],
          ),
        ),
      ),
    );
  }
}
