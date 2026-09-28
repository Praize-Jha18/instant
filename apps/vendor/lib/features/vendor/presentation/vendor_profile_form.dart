import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';
import '../../../core/utils/money_input.dart';
import '../../../core/widgets/location_picker.dart';
import '../../auth/presentation/auth_layout.dart';

/// Which parts of the profile the form edits.
enum VendorFormSection { basics, address, deliveryFee, hours, payout }

/// Editor for the vendor profile (`PATCH /vendor`). Used by registration
/// (step 2) and by settings. Produces a [VendorInput] with only the edited
/// sections populated.
class VendorProfileForm extends StatefulWidget {
  const VendorProfileForm({
    super.key,
    this.initial,
    required this.onSubmit,
    this.submitLabel = 'Save',
    this.busy = false,
    this.sections = VendorFormSection.values,
    this.showName = true,
  });

  final Vendor? initial;
  final Future<void> Function(VendorInput input) onSubmit;
  final String submitLabel;
  final bool busy;
  final List<VendorFormSection> sections;
  final bool showName;

  @override
  State<VendorProfileForm> createState() => _VendorProfileFormState();
}

class _VendorProfileFormState extends State<VendorProfileForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final _description = TextEditingController(text: widget.initial?.description ?? '');
  late final _line1 = TextEditingController(text: widget.initial?.address?.line1 ?? '');
  late final _city = TextEditingController(text: widget.initial?.address?.city ?? '');
  late final _state = TextEditingController(text: widget.initial?.address?.state ?? '');
  late final _lat = TextEditingController(text: widget.initial?.address?.lat.toString() ?? '');
  late final _lng = TextEditingController(text: widget.initial?.address?.lng.toString() ?? '');
  late final _base = TextEditingController(text: koboToNairaText(widget.initial?.deliveryFee?.baseKobo ?? 0));
  late final _perKm = TextEditingController(text: koboToNairaText(widget.initial?.deliveryFee?.perKmKobo ?? 0));
  late final _freeAbove = TextEditingController(
      text: widget.initial?.deliveryFee?.freeAboveKobo == null ? '' : koboToNairaText(widget.initial!.deliveryFee!.freeAboveKobo!));
  late final _radius = TextEditingController(text: widget.initial?.deliveryRadiusKm?.toString() ?? '10');
  late final _bank = TextEditingController(text: widget.initial?.payout?.bankName ?? '');
  late final _accountNumber = TextEditingController(text: widget.initial?.payout?.accountNumber ?? '');
  late final _accountName = TextEditingController(text: widget.initial?.payout?.accountName ?? '');
  late final List<OpeningHours> _hours = _initialHours(widget.initial?.openingHours ?? const []);

  static List<OpeningHours> _initialHours(List<OpeningHours> existing) => [
        for (var d = 1; d <= 7; d++)
          existing.where((h) => h.weekday == d).firstOrNull ?? OpeningHours(weekday: d, closed: existing.isNotEmpty),
      ];

  bool _has(VendorFormSection s) => widget.sections.contains(s);

  @override
  void dispose() {
    for (final c in [_name, _description, _line1, _city, _state, _lat, _lng, _base, _perKm, _freeAbove, _radius, _bank, _accountNumber, _accountName]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickOnMap() async {
    final lat = double.tryParse(_lat.text);
    final lng = double.tryParse(_lng.text);
    final picked = await showLocationPicker(context, initial: lat != null && lng != null ? GeoPoint(lat: lat, lng: lng) : null);
    if (picked == null) return;
    setState(() {
      _lat.text = picked.lat.toStringAsFixed(6);
      _lng.text = picked.lng.toStringAsFixed(6);
    });
  }

  Future<void> _submit() async {
    if (widget.busy) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    final input = VendorInput(
      name: _has(VendorFormSection.basics) && widget.showName ? _name.text.trim() : null,
      description: _has(VendorFormSection.basics) ? _description.text.trim() : null,
      address: _has(VendorFormSection.address)
          ? VendorAddress(
              line1: _line1.text.trim(),
              city: _city.text.trim(),
              state: _state.text.trim(),
              lat: double.parse(_lat.text.trim()),
              lng: double.parse(_lng.text.trim()),
            )
          : null,
      deliveryFee: _has(VendorFormSection.deliveryFee)
          ? DeliveryFeeConfig(
              baseKobo: parseNairaToKobo(_base.text) ?? 0,
              perKmKobo: parseNairaToKobo(_perKm.text) ?? 0,
              freeAboveKobo: _freeAbove.text.trim().isEmpty ? null : parseNairaToKobo(_freeAbove.text),
            )
          : null,
      deliveryRadiusKm: _has(VendorFormSection.deliveryFee) ? double.tryParse(_radius.text.trim()) : null,
      openingHours: _has(VendorFormSection.hours) ? _hours : null,
      payout: _has(VendorFormSection.payout) && _accountNumber.text.trim().isNotEmpty
          ? PayoutAccount(
              bankName: _bank.text.trim(),
              accountNumber: _accountNumber.text.trim(),
              accountName: _accountName.text.trim(),
            )
          : null,
    );
    await widget.onSubmit(input);
  }

  String? _coord(String? v, double max, String label) {
    final d = double.tryParse((v ?? '').trim());
    if (d == null) return '$label is required (pick on map)';
    if (d.abs() > max) return 'Invalid $label';
    return null;
  }

  String? _money(String? v, {bool optional = false}) {
    if ((v ?? '').trim().isEmpty) return optional ? null : 'Enter an amount';
    return parseNairaToKobo(v!) == null ? 'Enter a valid amount' : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_has(VendorFormSection.basics)) ...[
            _Section(
              title: 'Business',
              children: [
                if (widget.showName) ...[
                  AppTextField(
                      controller: _name,
                      label: 'Business name',
                      validator: (v) => requiredField(v, 'Business name'),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words),
                  AppSpacing.gapLg,
                ],
                AppTextField(
                    controller: _description,
                    label: 'Description',
                    hint: 'What do you sell?',
                    maxLines: 4,
                    minLines: 2,
                    textCapitalization: TextCapitalization.sentences),
              ],
            ),
          ],
          if (_has(VendorFormSection.address)) ...[
            _Section(
              title: 'Address',
              children: [
                AppTextField(
                    controller: _line1,
                    label: 'Street address',
                    validator: (v) => requiredField(v, 'Address'),
                    textInputAction: TextInputAction.next),
                AppSpacing.gapLg,
                Row(
                  children: [
                    Expanded(
                        child: AppTextField(
                            controller: _city,
                            label: 'City',
                            validator: (v) => requiredField(v, 'City'),
                            textInputAction: TextInputAction.next)),
                    AppSpacing.gapMd,
                    Expanded(
                        child: AppTextField(
                            controller: _state,
                            label: 'State',
                            validator: (v) => requiredField(v, 'State'),
                            textInputAction: TextInputAction.next)),
                  ],
                ),
                AppSpacing.gapLg,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _lat,
                        label: 'Latitude',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (v) => _coord(v, 90, 'latitude'),
                      ),
                    ),
                    AppSpacing.gapMd,
                    Expanded(
                      child: AppTextField(
                        controller: _lng,
                        label: 'Longitude',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (v) => _coord(v, 180, 'longitude'),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton.secondary(label: 'Pick on map', icon: Icons.location_on_outlined, onPressed: _pickOnMap),
                ),
              ],
            ),
          ],
          if (_has(VendorFormSection.deliveryFee)) ...[
            _Section(
              title: 'Delivery fees',
              subtitle: 'Fee = base + per km × distance. Free when the order is above the threshold.',
              children: [
                Row(
                  children: [
                    Expanded(child: _MoneyField(controller: _base, label: 'Base fee', validator: _money)),
                    AppSpacing.gapMd,
                    Expanded(child: _MoneyField(controller: _perKm, label: 'Per km', validator: _money)),
                  ],
                ),
                AppSpacing.gapLg,
                Row(
                  children: [
                    Expanded(
                        child: _MoneyField(
                            controller: _freeAbove, label: 'Free above (optional)', validator: (v) => _money(v, optional: true))),
                    AppSpacing.gapMd,
                    Expanded(
                      child: AppTextField(
                        controller: _radius,
                        label: 'Delivery radius (km)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          final d = double.tryParse((v ?? '').trim());
                          if (d == null || d < 0.5 || d > 200) return '0.5 – 200 km';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          if (_has(VendorFormSection.hours)) ...[
            _Section(
              title: 'Opening hours',
              children: [
                for (var i = 0; i < _hours.length; i++) _HoursRow(hours: _hours[i], onChanged: (h) => setState(() => _hours[i] = h)),
              ],
            ),
          ],
          if (_has(VendorFormSection.payout)) ...[
            _Section(
              title: 'Payout bank account',
              subtitle: 'Payouts are manual bank transfers made by the platform team.',
              children: [
                AppTextField(controller: _bank, label: 'Bank name', textInputAction: TextInputAction.next),
                AppSpacing.gapLg,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _accountNumber,
                        label: 'Account number',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return null;
                          if (!RegExp(r'^\d{10}$').hasMatch(t)) return '10 digits';
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.gapMd,
                    Expanded(
                        child: AppTextField(
                            controller: _accountName,
                            label: 'Account name',
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (_) => _submit())),
                  ],
                ),
              ],
            ),
          ],
          AppSpacing.gapLg,
          AppButton.primary(label: widget.submitLabel, onPressed: _submit, loading: widget.busy, expanded: true, size: AppButtonSize.large),
          AppSpacing.gapSm,
          Text('Press Enter in any field to submit.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.subtitle, required this.children});
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null) ...[
              AppSpacing.gapXs,
              Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            AppSpacing.gapLg,
            ...children,
          ],
        ),
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({required this.controller, required this.label, this.validator});
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => AppTextField(
        controller: controller,
        label: label,
        prefix: const Text('₦ '),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: nairaInputFormatters,
        validator: validator,
        textInputAction: TextInputAction.next,
      );
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({required this.hours, required this.onChanged});
  final OpeningHours hours;
  final ValueChanged<OpeningHours> onChanged;

  Future<void> _pick(BuildContext context, bool open) async {
    final current = open ? hours.open : hours.close;
    final parts = current.split(':');
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.tryParse(parts[0]) ?? 9, minute: int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0),
    );
    if (t == null) return;
    final s = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    onChanged(open ? hours.copyWith(open: s) : hours.copyWith(close: s));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(width: 96, child: Text(weekdayName(hours.weekday), style: theme.textTheme.bodyMedium)),
          Switch(value: !hours.closed, onChanged: (v) => onChanged(hours.copyWith(closed: !v))),
          const SizedBox(width: AppSpacing.sm),
          if (hours.closed)
            Text('Closed', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))
          else ...[
            _TimeChip(label: hours.open, onTap: () => _pick(context, true)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm), child: Text('–')),
            _TimeChip(label: hours.close, onTap: () => _pick(context, false)),
          ],
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionChip(label: Text(label), onPressed: onTap, avatar: const Icon(Icons.schedule, size: 16));
}
