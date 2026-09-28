import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

class AdminPayoutsScreen extends ConsumerStatefulWidget {
  const AdminPayoutsScreen({super.key});

  @override
  ConsumerState<AdminPayoutsScreen> createState() => _AdminPayoutsScreenState();
}

class _AdminPayoutsScreenState extends ConsumerState<AdminPayoutsScreen> {
  PayoutStatus? _filter = PayoutStatus.requested;
  Object? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  Future<void> _refresh() async {
    try {
      await ref.read(adminRepositoryProvider).refreshPayouts();
      if (mounted) setState(() => _error = null);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _markPaid(Payout p, String vendorName) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark payout as paid'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Money.fromKobo(p.amountKobo).format()} to $vendorName'),
            AppSpacing.gapLg,
            AppTextField(controller: ctrl, label: 'Bank transfer reference', hint: 'e.g. TRF-2026-0001', autofocus: true, onSubmitted: (_) => Navigator.of(ctx).pop(true)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Mark paid')),
        ],
      ),
    );
    final reference = ctrl.text.trim();
    ctrl.dispose();
    if (ok != true) return;
    try {
      await ref.read(adminRepositoryProvider).markPayoutPaid(p.id, reference: reference.isEmpty ? null : reference);
      if (mounted) showSnack(context, 'Payout marked as paid');
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final payouts = ref.watch(payoutsStreamProvider);
    final vendors = ref.watch(vendorsStreamProvider).value ?? const <Vendor>[];
    final byId = {for (final v in vendors) v.id: v};
    final online = ref.watch(isOnlineProvider);
    final theme = Theme.of(context);
    return AppPage(
      title: 'Payouts',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: FilterChips<PayoutStatus>(
              options: PayoutStatus.values,
              selected: _filter,
              labelOf: (s) => titleCase(s.json),
              counts: {for (final s in PayoutStatus.values) s: (payouts.value ?? const <Payout>[]).where((p) => p.status == s).length},
              onSelected: (s) => setState(() => _filter = s),
            ),
          ),
          Expanded(
            child: payouts.when(
              loading: () => const SkeletonList(),
              error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
              data: (all) {
                final list = all.where((p) => _filter == null || p.status == _filter).toList();
                if (list.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(children: [
                      const SizedBox(height: 80),
                      if (_error != null && all.isEmpty)
                        ErrorState(offline: isOfflineError(_error), message: errorMessage(_error), onRetry: _refresh)
                      else
                        const EmptyState(icon: Icons.payments_outlined, title: 'No payouts here'),
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
                      final p = list[i];
                      final vendor = byId[p.vendorId];
                      final name = p.vendorName ?? vendor?.name ?? 'Vendor ${p.vendorId.substring(p.vendorId.length - 4)}';
                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(child: Text(name, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    StatusChip.payout(p.status, dense: true),
                                  ]),
                                  const SizedBox(height: AppSpacing.xxs),
                                  MoneyText.kobo(p.amountKobo, emphasize: true, style: theme.textTheme.titleMedium),
                                  Text(
                                    [
                                      'requested ${formatDateTime(p.createdAt)}',
                                      if (vendor?.payout != null) '${vendor!.payout!.bankName} ${vendor.payout!.accountNumber} · ${vendor.payout!.accountName}',
                                      if (p.paidAt != null) 'paid ${formatDateTime(p.paidAt)}',
                                      if ((p.reference ?? '').isNotEmpty) 'ref ${p.reference}',
                                    ].join(' · '),
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            if (p.status == PayoutStatus.requested) ...[
                              const SizedBox(width: AppSpacing.sm),
                              AppButton.primary(
                                label: 'Mark paid',
                                icon: Icons.check_rounded,
                                size: AppButtonSize.small,
                                onPressed: online ? () => _markPaid(p, name) : null,
                                tooltip: 'You are offline',
                              ),
                            ],
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
}
