import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/domain/validators.dart';

/// What the rider captured as proof of delivery.
class ProofInput {
  const ProofInput({this.otp, this.photoBytes, this.photoContentType = 'image/jpeg'});
  final String? otp;
  final Uint8List? photoBytes;
  final String photoContentType;
}

/// Bottom sheet: enter the customer's code or take a photo.
Future<ProofInput?> showProofSheet(BuildContext context, {bool online = true}) =>
    AppBottomSheet.show<ProofInput>(context, title: 'Proof of delivery', builder: (_) => _ProofSheet(online: online));

class _ProofSheet extends StatefulWidget {
  const _ProofSheet({required this.online});
  final bool online;

  @override
  State<_ProofSheet> createState() => _ProofSheetState();
}

class _ProofSheetState extends State<_ProofSheet> {
  int _mode = 0; // 0 = code, 1 = photo
  final _form = GlobalKey<FormState>();
  final _otp = TextEditingController();
  Uint8List? _photo;
  bool _picking = false;
  String? _photoError;

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    setState(() {
      _picking = true;
      _photoError = null;
    });
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1280,
        requestFullMetadata: false,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (e) {
      if (mounted) setState(() => _photoError = 'Could not open the camera. Check the camera permission.');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _submit() {
    if (_mode == 0) {
      if (!(_form.currentState?.validate() ?? false)) return;
      Navigator.of(context).pop(ProofInput(otp: _otp.text.trim()));
    } else {
      final p = _photo;
      if (p == null) {
        setState(() => _photoError = 'Take a photo of the handed-over order first.');
        return;
      }
      Navigator.of(context).pop(ProofInput(photoBytes: p));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.online)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: context.semanticColors.warningContainer, borderRadius: AppRadius.smAll),
              child: Text(
                'You are offline. The proof will be saved on this phone and submitted automatically when you reconnect.',
                style: context.text.bodySmall?.copyWith(color: context.semanticColors.onWarningContainer),
              ),
            ),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, icon: Icon(Icons.pin_outlined), label: Text('Customer code')),
              ButtonSegment(value: 1, icon: Icon(Icons.photo_camera_outlined), label: Text('Photo')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          AppSpacing.gapXl,
          AnimatedSwitcher(
            duration: AppMotion.normal,
            switchInCurve: AppMotion.curve,
            child: _mode == 0
                ? Form(
                    key: _form,
                    child: AppTextField(
                      key: const ValueKey('otp'),
                      controller: _otp,
                      label: 'Code from the customer',
                      hint: '4 to 8 digits',
                      prefixIcon: Icons.lock_outline_rounded,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      maxLength: 8,
                      validator: Validators.otp,
                      onSubmitted: (_) => _submit(),
                    ),
                  )
                : Column(
                    key: const ValueKey('photo'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedPressable(
                        onTap: _picking ? null : _takePhoto,
                        borderRadius: AppRadius.mdAll,
                        child: Container(
                          height: 200,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: AppRadius.mdAll,
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                          child: _photo != null
                              ? Image.memory(_photo!, fit: BoxFit.cover)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_picking)
                                      const CircularProgressIndicator()
                                    else
                                      Icon(Icons.photo_camera_outlined, size: 40, color: scheme.onSurfaceVariant),
                                    AppSpacing.gapSm,
                                    Text('Tap to take a photo', style: context.text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                                  ],
                                ),
                        ),
                      ),
                      if (_photo != null) ...[
                        AppSpacing.gapSm,
                        AppButton.ghost(label: 'Retake', icon: Icons.refresh_rounded, onPressed: _takePhoto),
                      ],
                      if (_photoError != null) ...[
                        AppSpacing.gapSm,
                        Text(_photoError!, style: context.text.bodySmall?.copyWith(color: scheme.error)),
                      ],
                    ],
                  ),
          ),
          AppSpacing.gapXl,
          AppButton.primary(
            label: widget.online ? 'Confirm delivery' : 'Save proof',
            icon: Icons.check_circle_outline_rounded,
            size: AppButtonSize.large,
            onPressed: _submit,
          ),
          AppSpacing.gapSm,
          AppButton.ghost(label: 'Cancel', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
