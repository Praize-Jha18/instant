import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/geo.dart';
import '../../../core/validators.dart';
import '../../catalog/data/location_controller.dart';
import '../data/address_providers.dart';

/// Add / edit an address with a map pin and manual fields. Saves through the
/// outbox so it works offline.
class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({super.key, this.addressId});

  final String? addressId;

  bool get isEdit => addressId != null;

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController(text: 'Home');
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _phone = TextEditingController();
  bool _isDefault = false;
  bool _saving = false;
  bool _locating = false;
  bool _seeded = false;
  GeoPoint _pin = kDefaultMapCenter;
  GoogleMapController? _map;

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) {
      final current = ref.read(locationProvider).value;
      if (current != null) _pin = current;
    }
  }

  @override
  void dispose() {
    for (final c in [_label, _line1, _line2, _city, _state, _phone]) {
      c.dispose();
    }
    _map?.dispose();
    super.dispose();
  }

  void _seed(Address a) {
    if (_seeded) return;
    _seeded = true;
    _label.text = a.label;
    _line1.text = a.line1;
    _line2.text = a.line2 ?? '';
    _city.text = a.city;
    _state.text = a.state;
    _phone.text = a.phone ?? '';
    _isDefault = a.isDefault;
    _pin = GeoPoint(lat: a.lat, lng: a.lng);
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    final controller = ref.read(locationProvider.notifier);
    final ok = await controller.request();
    final point = ref.read(locationProvider).value;
    if (!mounted) return;
    setState(() => _locating = false);
    if (!ok || point == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get your location. Move the pin manually.')),
      );
      return;
    }
    setState(() => _pin = point);
    await _map?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(point.lat, point.lng), 16));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref.read(addressActionsProvider).save(
            id: widget.addressId,
            label: _label.text,
            line1: _line1.text,
            line2: _line2.text,
            city: _city.text,
            state: _state.text,
            lat: _pin.lat,
            lng: _pin.lng,
            phone: _phone.text,
            isDefault: _isDefault,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? 'Address updated' : 'Address saved')),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      final existing = ref.watch(addressProvider(widget.addressId!)).value;
      if (existing != null) _seed(existing);
    }
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit address' : 'New address')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: [
            ClipRRect(
              borderRadius: AppRadius.mdAll,
              child: SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    GoogleMap(
                      key: ValueKey('map-${_pin.lat.toStringAsFixed(3)}-${_pin.lng.toStringAsFixed(3)}-$_seeded'),
                      initialCameraPosition: CameraPosition(target: LatLng(_pin.lat, _pin.lng), zoom: 15),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      onMapCreated: (c) => _map = c,
                      onCameraMove: (pos) => _pin = GeoPoint(lat: pos.target.latitude, lng: pos.target.longitude),
                      onCameraIdle: () => setState(() {}),
                    ),
                    // Fixed centre pin: the map moves under it.
                    IgnorePointer(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 36),
                          child: Icon(Icons.location_on_rounded, size: 40, color: scheme.primary),
                        ),
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.sm,
                      bottom: AppSpacing.sm,
                      child: FloatingActionButton.small(
                        heroTag: null,
                        onPressed: _locating ? null : _useMyLocation,
                        tooltip: 'Use my location',
                        child: _locating
                            ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.my_location_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pin: ${_pin.lat.toStringAsFixed(5)}, ${_pin.lng.toStringAsFixed(5)} · drag the map to adjust',
              style: context.text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _label,
              label: 'Label',
              hint: 'Home, Work…',
              prefixIcon: Icons.label_outline_rounded,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _line1,
              label: 'Street address',
              prefixIcon: Icons.home_outlined,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.streetAddressLine1],
              validator: Validators.required('the street address'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _line2,
              label: 'Apartment, floor (optional)',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.streetAddressLine2],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _city,
                    label: 'City',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.addressCity],
                    validator: Validators.required('the city'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _state,
                    label: 'State',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.addressState],
                    validator: Validators.required('the state'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _phone,
              label: 'Contact phone (optional)',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: Validators.phone,
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Use as default address'),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: widget.isEdit ? 'Save changes' : 'Save address',
              expanded: true,
              size: AppButtonSize.large,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
