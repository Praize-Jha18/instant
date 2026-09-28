import 'package:core_models/core_models.dart';
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
import 'vendor_picker_sheet.dart';

const kVehicleTypes = ['Motorcycle', 'Bicycle', 'Car', 'Van', 'On foot'];

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _plate = TextEditingController();
  String? _vehicle = kVehicleTypes.first;
  Vendor? _vendor;
  bool _vendorMissing = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password, _plate]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickVendor() async {
    final v = await showVendorPicker(context);
    if (v != null && mounted) {
      setState(() {
        _vendor = v;
        _vendorMissing = false;
      });
      // Cache so Profile can show the vendor name offline.
      await ref.read(localStoreProvider).upsert(Collections.vendors, v);
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _vendorMissing = _vendor == null;
    });
    final valid = _form.currentState?.validate() ?? false;
    if (!valid || _vendor == null) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await ref.read(authControllerProvider.notifier).register(
            email: _email.text,
            password: _password.text,
            fullName: _name.text,
            phone: _phone.text,
            vendorId: _vendor!.id,
            vehicleType: _vehicle,
            plateNumber: _plate.text.trim().isEmpty ? null : _plate.text.trim().toUpperCase(),
          );
    } catch (e) {
      setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    final scheme = context.colors;
    return AuthScaffold(
      title: 'Join as a rider',
      subtitle: 'Your vendor will approve your account before you can go online.',
      showBack: true,
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _name,
              label: 'Full name',
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: Validators.fullName,
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.gapLg,
            AppTextField.email(controller: _email, validator: Validators.email),
            AppSpacing.gapLg,
            AppTextField(
              controller: _phone,
              label: 'Phone (optional)',
              hint: '+234…',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
              validator: Validators.phone,
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.gapLg,
            AppTextField.password(
              controller: _password,
              validator: Validators.password,
              textInputAction: TextInputAction.next,
            ),
            AppSpacing.gapXl,
            SectionHeader(title: 'Your vendor', padding: EdgeInsets.zero),
            AppSpacing.gapSm,
            AppCard(
              onTap: _busy ? null : _pickVendor,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _vendor == null ? scheme.surfaceContainerHighest : scheme.primaryContainer,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: _vendor == null ? scheme.onSurfaceVariant : scheme.onPrimaryContainer,
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _vendor?.name ?? 'Select the vendor you ride for',
                          style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        if (_vendor?.address != null)
                          Text(
                            '${_vendor!.address!.line1}, ${_vendor!.address!.city}',
                            style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
            if (_vendorMissing)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm, left: AppSpacing.xs),
                child: Text('Please choose your vendor', style: context.text.bodySmall?.copyWith(color: scheme.error)),
              ),
            AppSpacing.gapXl,
            SectionHeader(title: 'Vehicle', padding: EdgeInsets.zero),
            AppSpacing.gapSm,
            DropdownButtonFormField<String>(
              initialValue: _vehicle,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.two_wheeler_outlined)),
              items: [for (final t in kVehicleTypes) DropdownMenuItem(value: t, child: Text(t))],
              onChanged: _busy ? null : (v) => setState(() => _vehicle = v),
            ),
            AppSpacing.gapLg,
            AppTextField(
              controller: _plate,
              label: 'Plate number (optional)',
              hint: 'ABC-123-XY',
              prefixIcon: Icons.pin_outlined,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            AppSpacing.gapMd,
            Text(
              'Identity documents can be added from your profile once your vendor approves you.',
              style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (_error != null) ...[
              AppSpacing.gapLg,
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: context.semanticColors.dangerContainer, borderRadius: AppRadius.smAll),
                child: Text(_error!, style: context.text.bodyMedium?.copyWith(color: context.semanticColors.onDangerContainer)),
              ),
            ],
            AppSpacing.gapXl,
            AppButton.primary(
              label: 'Create account',
              expanded: true,
              size: AppButtonSize.large,
              loading: _busy,
              onPressed: online ? _submit : null,
              tooltip: online ? null : 'Registration needs a connection',
            ),
            AppSpacing.gapLg,
            AppButton.ghost(
              label: 'Already have an account? Sign in',
              onPressed: _busy ? null : () => context.go(Routes.login),
            ),
          ],
        ),
      ),
    );
  }
}
