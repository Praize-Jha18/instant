import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors.dart';

/// Search-and-pick an active vendor via `GET /vendors?q=`.
Future<Vendor?> showVendorPicker(BuildContext context) =>
    AppBottomSheet.show<Vendor>(context, title: 'Choose your vendor', builder: (_) => const _VendorPicker());

class _VendorPicker extends ConsumerStatefulWidget {
  const _VendorPicker();

  @override
  ConsumerState<_VendorPicker> createState() => _VendorPickerState();
}

class _VendorPickerState extends ConsumerState<_VendorPicker> {
  final _query = TextEditingController();
  Timer? _debounce;
  List<Vendor> _results = const [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(q));
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(apiClientProvider).catalog.vendors(q: q.trim(), limit: 30);
      if (!mounted) return;
      setState(() => _results = page.items);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(apiClientProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _query,
          hint: 'Search vendors by name',
          prefixIcon: Icons.search_rounded,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: _search,
        ),
        AppSpacing.gapMd,
        Flexible(
          child: _loading
              ? const SkeletonList(itemCount: 5, padding: EdgeInsets.symmetric(vertical: AppSpacing.md))
              : _error != null
                  ? ErrorState(
                      compact: true,
                      offline: isOfflineError(_error!),
                      message: friendlyError(_error!),
                      onRetry: () => _search(_query.text),
                    )
                  : _results.isEmpty
                      ? const EmptyState(
                          compact: true,
                          icon: Icons.storefront_outlined,
                          title: 'No vendors found',
                          message: 'Try a different name, or ask your vendor how they are listed.',
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _results.length,
                          itemBuilder: (context, i) {
                            final v = _results[i];
                            return FadeSlideIn.staggered(
                              index: i,
                              child: AppListTile(
                                title: v.name,
                                subtitle: v.address == null ? null : '${v.address!.line1}, ${v.address!.city}',
                                leading: v.logoImageId == null
                                    ? null
                                    : AppImage(
                                        url: api.catalog.imageUrl(v.logoImageId!, thumb: true),
                                        width: 44,
                                        height: 44,
                                      ),
                                leadingIcon: v.logoImageId == null ? Icons.storefront_outlined : null,
                                onTap: () => Navigator.of(context).pop(v),
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
