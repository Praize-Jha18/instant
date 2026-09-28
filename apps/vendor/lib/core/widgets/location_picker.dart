import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Lagos, used when nothing better is known.
const GeoPoint defaultMapCenter = GeoPoint(lat: 6.5244, lng: 3.3792);

/// Full-screen picker: tap the map to drop a pin, or type lat/lng. Works
/// without a Maps key too (the manual fields still submit).
Future<GeoPoint?> showLocationPicker(BuildContext context, {GeoPoint? initial}) => Navigator.of(context, rootNavigator: true)
    .push<GeoPoint>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => _LocationPickerPage(initial: initial)));

class _LocationPickerPage extends StatefulWidget {
  const _LocationPickerPage({this.initial});
  final GeoPoint? initial;

  @override
  State<_LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<_LocationPickerPage> {
  late GeoPoint _point = widget.initial ?? defaultMapCenter;
  late final _lat = TextEditingController(text: _point.lat.toStringAsFixed(6));
  late final _lng = TextEditingController(text: _point.lng.toStringAsFixed(6));
  GoogleMapController? _controller;

  @override
  void dispose() {
    _lat.dispose();
    _lng.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _set(GeoPoint p, {bool move = false}) {
    setState(() => _point = p);
    _lat.text = p.lat.toStringAsFixed(6);
    _lng.text = p.lng.toStringAsFixed(6);
    if (move) _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(p.lat, p.lng)));
  }

  void _applyManual() {
    final lat = double.tryParse(_lat.text.trim());
    final lng = double.tryParse(_lng.text.trim());
    if (lat == null || lng == null || lat.abs() > 90 || lng.abs() > 180) return;
    _set(GeoPoint(lat: lat, lng: lng), move: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin your location'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(_point), child: const Text('Use this location')),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(_point.lat, _point.lng), zoom: 14),
              onMapCreated: (c) => _controller = c,
              onTap: (ll) => _set(GeoPoint(lat: ll.latitude, lng: ll.longitude)),
              markers: {
                Marker(
                  markerId: const MarkerId('pin'),
                  position: LatLng(_point.lat, _point.lng),
                  draggable: true,
                  onDragEnd: (ll) => _set(GeoPoint(lat: ll.latitude, lng: ll.longitude)),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
          Material(
            color: theme.colorScheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppSpacing.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Tap the map or enter coordinates manually.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    AppSpacing.gapSm,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _lat,
                            label: 'Latitude',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                            onSubmitted: (_) => _applyManual(),
                          ),
                        ),
                        AppSpacing.gapMd,
                        Expanded(
                          child: AppTextField(
                            controller: _lng,
                            label: 'Longitude',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                            onSubmitted: (_) => _applyManual(),
                          ),
                        ),
                        AppSpacing.gapMd,
                        Padding(
                          padding: const EdgeInsets.only(top: 26),
                          child: AppButton.secondary(label: 'Apply', onPressed: _applyManual),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
