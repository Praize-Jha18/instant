import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

class AdminVendorsScreen extends ConsumerStatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  ConsumerState<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends ConsumerState<AdminVendorsScreen> {
  VendorStatus? _status = VendorStatus.pending;
  final _search = TextEditingController();
  Object? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      await ref.read(adminRepositoryProvider).refreshVendors();
      if (mounted) setState(() => _error = null);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _act(Future<void> Function() f, String done) async {
    try {
      await f();
      if (mounted) showSnack(context, done);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorsStreamProvider);
    final online = ref.watch(isOnlineProvider);
    final repo = ref.read(adminRepositoryProvider);
    final theme = Theme.of(context);
    return AppPage(
      title: 'Vendors',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: AppTextField(controller: _search, hint: 'Search vendors', prefixIcon: Icons.search_rounded, onChanged: (_) => setState(() {})),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: FilterChips<VendorStatus>(
              options: VendorStatus.values,
              selected: _status,
              labelOf: (s) => titleCase(s.json),
              counts: {for (final s in VendorStatus.values) s: (vendors.value ?? const <Vendor>[]).where((v) => v.status == s).length},
              onSelected: (s) => setState(() => _status = s),
            ),
          ),
          Expanded(
            child: vendors.when(
              loading: () => const SkeletonList(),
              error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
              data: (all) {
                final q = _search.text.trim().toLowerCase();
                final list = all
                    .where((v) => _status == null || v.status == _status)
                    .where((v) => q.isEmpty || v.name.toLowerCase().contains(q) || v.slug.contains(q) || (v.address?.city.toLowerCase().contains(q) ?? false))
                    .toList();
                if (list.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(children: [
                      const SizedBox(height: 80),
                      if (_error != null && all.isEmpty)
                        ErrorState(offline: isOfflineError(_error), message: errorMessage(_error), onRetry: _refresh)
                      else
                        EmptyState(icon: Icons.storefront_outlined, title: 'No ${_status == null ? '' : '${_status!.json} '}vendors'),
                    ]),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: AppSpacing.page,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => AppSpacing.gapSm,
                    itemBuilder: (context, i) {
                      final v = list[i];
                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        onTap: () => _showDetail(context, v),
                        child: Row(
                          children: [
                            CircleAvatar(child: Text(v.name.isEmpty ? '?' : v.name.characters.first.toUpperCase())),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(child: Text(v.name, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    StatusChip.vendor(v.status, dense: true),
                                  ]),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    [
                                      if (v.address != null) '${v.address!.city}, ${v.address!.state}',
                                      'commission ${v.commissionBps / 100}%',
                                      'joined ${formatDate(v.createdAt)}',
                                    ].join(' · '),
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            if (v.status != VendorStatus.active)
                              AppButton.primary(
                                label: 'Approve',
                                size: AppButtonSize.small,
                                onPressed: online ? () => _act(() => repo.approveVendor(v.id), '${v.name} approved') : null,
                                tooltip: 'You are offline',
                              )
                            else
                              AppButton.secondary(
                                label: 'Suspend',
                                size: AppButtonSize.small,
                                onPressed: online
                                    ? () async {
                                        final ok = await AppBottomSheet.confirm(context,
                                            title: 'Suspend ${v.name}?', message: 'Their store goes offline immediately.', confirmLabel: 'Suspend', destructive: true);
                                        if (ok) await _act(() => repo.suspendVendor(v.id), '${v.name} suspended');
                                      }
                                    : null,
                                tooltip: 'You are offline',
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Vendor v) {
    AppBottomSheet.show<void>(
      context,
      title: v.name,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip.vendor(v.status),
            AppSpacing.gapMd,
            if ((v.description ?? '').isNotEmpty) ...[Text(v.description!), AppSpacing.gapMd],
            DetailRow(label: 'Slug', value: v.slug),
            DetailRow(label: 'Owner', value: v.ownerUserId),
            DetailRow(label: 'Address', value: v.address == null ? '—' : '${v.address!.line1}, ${v.address!.city}, ${v.address!.state} (${v.address!.lat}, ${v.address!.lng})'),
            DetailRow(
                label: 'Delivery',
                value: v.deliveryFee == null
                    ? '—'
                    : 'base ${Money.fromKobo(v.deliveryFee!.baseKobo).format(showDecimals: false)} + ${Money.fromKobo(v.deliveryFee!.perKmKobo).format(showDecimals: false)}/km · ${v.deliveryRadiusKm ?? '—'} km'),
            DetailRow(
                label: 'Hours',
                value: v.openingHours.isEmpty
                    ? '—'
                    : v.openingHours.where((h) => !h.closed).map((h) => '${weekdayName(h.weekday).substring(0, 3)} ${h.open}–${h.close}').join(', ')),
            DetailRow(label: 'Payout', value: v.payout == null ? '—' : '${v.payout!.bankName} ${v.payout!.accountNumber} (${v.payout!.accountName})'),
            DetailRow(label: 'Commission', value: '${v.commissionBps / 100}%'),
            DetailRow(label: 'Created', value: formatDateTime(v.createdAt)),
            AppSpacing.gapLg,
            AppButton.secondary(
              label: 'Change commission',
              icon: Icons.percent_rounded,
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _editCommission(context, v);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editCommission(BuildContext context, Vendor v) async {
    final ctrl = TextEditingController(text: (v.commissionBps / 100).toString());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Commission (%)'),
        content: AppTextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );
    final pct = double.tryParse(ctrl.text.trim());
    ctrl.dispose();
    if (ok != true || pct == null || pct < 0 || pct > 100) return;
    await _act(() => ref.read(adminRepositoryProvider).updateVendor(v.id, VendorInput(commissionBps: (pct * 100).round())), 'Commission updated');
  }
}
