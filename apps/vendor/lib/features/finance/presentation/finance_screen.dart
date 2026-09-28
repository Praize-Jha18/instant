import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/session.dart';
import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/money_input.dart';
import '../../../core/widgets/app_page.dart';
import '../data/finance_repository.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      await ref.read(financeRepositoryProvider).refresh();
    } catch (_) {
      await refreshCollections(ref, const [Collections.vendorLedger, Collections.payouts]);
    }
  }

  int _balance(List<VendorLedgerEntry> ledger) {
    if (ledger.isEmpty) return 0;
    // Newest first; the latest row carries the running balance when present.
    final latest = ledger.first;
    if (latest.balanceAfterKobo != 0) return latest.balanceAfterKobo;
    return ledger.fold(0, (acc, e) => acc + e.amountKobo);
  }

  @override
  Widget build(BuildContext context) {
    final ledger = ref.watch(ledgerStreamProvider);
    final payouts = ref.watch(payoutsStreamProvider);
    final vendor = ref.watch(sessionProvider.select((s) => s.vendor));
    final online = ref.watch(isOnlineProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final entries = ledger.value ?? const <VendorLedgerEntry>[];
    final balance = _balance(entries);
    final pendingPayout = (payouts.value ?? const <Payout>[]).where((p) => p.status == PayoutStatus.requested).fold(0, (a, p) => a + p.amountKobo);

    return AppPage(
      title: 'Finance',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      bottom: TabBar(controller: _tabs, tabs: const [Tab(text: 'Ledger'), Tab(text: 'Payouts')]),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.page,
            child: AppCard(
              color: scheme.primaryContainer.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available balance', style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: AppSpacing.xs),
                        MoneyText.kobo(balance, emphasize: true, style: theme.textTheme.headlineMedium),
                        if (pendingPayout > 0)
                          Text('${Money.fromKobo(pendingPayout).format()} payout requested',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  AppButton.primary(
                    label: 'Request payout',
                    icon: Icons.account_balance_outlined,
                    onPressed: online && balance > 0 ? () => _requestPayout(context, balance, vendor) : null,
                    tooltip: !online ? 'You are offline' : 'No balance to pay out',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                ledger.when(
                  loading: () => const SkeletonList(),
                  error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
                  data: (list) => RefreshIndicator(
                    onRefresh: _refresh,
                    child: list.isEmpty
                        ? ListView(children: const [
                            SizedBox(height: 60),
                            EmptyState(icon: Icons.receipt_outlined, title: 'No ledger entries', message: 'Sales and commission rows appear once orders are delivered.'),
                          ])
                        : ListView.separated(
                            padding: AppSpacing.pageH,
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, i) {
                              final e = list[i];
                              return AppListTile(
                                leadingIcon: switch (e.type) {
                                  LedgerEntryType.sale => Icons.shopping_bag_outlined,
                                  LedgerEntryType.commission => Icons.percent_rounded,
                                  LedgerEntryType.refund => Icons.undo_rounded,
                                  LedgerEntryType.payout => Icons.account_balance_outlined,
                                },
                                title: titleCase(e.type.json),
                                subtitle: [
                                  formatDateTime(e.createdAt),
                                  if (e.subOrderId != null) 'order ${e.subOrderId!.substring(e.subOrderId!.length - 6)}',
                                  if ((e.note ?? '').isNotEmpty) e.note!,
                                ].join(' · '),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MoneyText.kobo(
                                      e.amountKobo,
                                      style: theme.textTheme.titleSmall,
                                      color: e.amountKobo >= 0 ? context.semanticColors.money : scheme.error,
                                    ),
                                    if (e.balanceAfterKobo != 0)
                                      Text('bal ${Money.fromKobo(e.balanceAfterKobo).format(showDecimals: false)}',
                                          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                                  ],
                                ),
                                showChevron: false,
                              );
                            },
                          ),
                  ),
                ),
                payouts.when(
                  loading: () => const SkeletonList(),
                  error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
                  data: (list) => RefreshIndicator(
                    onRefresh: _refresh,
                    child: list.isEmpty
                        ? ListView(children: const [
                            SizedBox(height: 60),
                            EmptyState(icon: Icons.account_balance_outlined, title: 'No payouts yet', message: 'Request a payout of your available balance; the platform team pays by bank transfer.'),
                          ])
                        : ListView.separated(
                            padding: AppSpacing.pageH,
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, i) {
                              final p = list[i];
                              return AppListTile(
                                leadingIcon: Icons.account_balance_outlined,
                                title: Money.fromKobo(p.amountKobo).format(),
                                subtitle: [
                                  'Requested ${formatDateTime(p.createdAt)}',
                                  if (p.paidAt != null) 'paid ${formatDateTime(p.paidAt)}',
                                  if ((p.reference ?? '').isNotEmpty) 'ref ${p.reference}',
                                ].join(' · '),
                                trailing: StatusChip.payout(p.status),
                                showChevron: false,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPayout(BuildContext context, int balance, Vendor? vendor) async {
    if (vendor?.payout == null) {
      final go = await AppBottomSheet.confirm(context,
          title: 'Add a bank account first',
          message: 'Payouts are sent to the bank account on your vendor profile.',
          confirmLabel: 'Go to settings');
      if (go && context.mounted) context.go('/settings');
      return;
    }
    final result = await AppBottomSheet.show<bool>(
      context,
      title: 'Request payout',
      builder: (_) => _RequestPayoutBody(balance: balance, account: vendor!.payout!),
    );
    if (result == true && context.mounted) showSnack(context, 'Payout requested');
  }
}

class _RequestPayoutBody extends ConsumerStatefulWidget {
  const _RequestPayoutBody({required this.balance, required this.account});
  final int balance;
  final PayoutAccount account;

  @override
  ConsumerState<_RequestPayoutBody> createState() => _RequestPayoutBodyState();
}

class _RequestPayoutBodyState extends ConsumerState<_RequestPayoutBody> {
  late final _amount = TextEditingController(text: koboToNairaText(widget.balance));
  final _note = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final kobo = parseNairaToKobo(_amount.text);
    if (kobo == null || kobo <= 0) {
      setState(() => _error = 'Enter a valid amount');
      return;
    }
    if (kobo > widget.balance) {
      setState(() => _error = 'Exceeds your available balance');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(financeRepositoryProvider).requestPayout(amountKobo: kobo, note: _note.text.trim().isEmpty ? null : _note.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorMessage(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = widget.account;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Paid to', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.xs),
              Text('${a.accountName} · ${a.accountNumber}', style: theme.textTheme.bodyLarge),
              Text(a.bankName, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        AppSpacing.gapLg,
        AppTextField(
          controller: _amount,
          label: 'Amount (available ${Money.fromKobo(widget.balance).format()})',
          prefix: const Text('₦ '),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: nairaInputFormatters,
          errorText: _error,
          autofocus: true,
          onSubmitted: (_) => _submit(),
        ),
        AppSpacing.gapLg,
        AppTextField(controller: _note, label: 'Note (optional)', onSubmitted: (_) => _submit()),
        AppSpacing.gapXl,
        AppButton.primary(label: 'Request payout', onPressed: _submit, loading: _busy, expanded: true),
      ],
    );
  }
}
