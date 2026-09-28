import 'dart:async';

import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/errors.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

/// Users are not synced (privacy), so this list is REST-backed with cursor
/// pagination, search and a role filter.
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _search = TextEditingController();
  UserRole? _role;
  final List<User> _users = [];
  String? _cursor;
  bool _loading = true;
  bool _loadingMore = false;
  Object? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(_reload);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _reload);
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref.read(adminRepositoryProvider).users(q: _search.text.trim(), role: _role);
      if (!mounted) return;
      setState(() {
        _users
          ..clear()
          ..addAll(page.items);
        _cursor = page.hasMore ? page.nextCursor : null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final cursor = _cursor;
    if (cursor == null || _loadingMore) return;
    setState(() => _loadingMore = true);
    try {
      final page = await ref.read(adminRepositoryProvider).users(q: _search.text.trim(), role: _role, cursor: cursor);
      if (!mounted) return;
      setState(() {
        _users.addAll(page.items);
        _cursor = page.hasMore ? page.nextCursor : null;
      });
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPage(
      title: 'Users',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _reload)],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: AppTextField(
              controller: _search,
              hint: 'Search by name or email',
              prefixIcon: Icons.search_rounded,
              textInputAction: TextInputAction.search,
              onChanged: _onSearch,
              onSubmitted: (_) => _reload(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: FilterChips<UserRole>(
              options: UserRole.values,
              selected: _role,
              labelOf: (r) => titleCase(r.json),
              onSelected: (r) {
                setState(() => _role = r);
                _reload();
              },
            ),
          ),
          Expanded(
            child: _loading && _users.isEmpty
                ? const SkeletonList()
                : _error != null && _users.isEmpty
                    ? ErrorState(offline: isOfflineError(_error), message: errorMessage(_error), onRetry: _reload)
                    : _users.isEmpty
                        ? const EmptyState(icon: Icons.people_outline, title: 'No users match')
                        : RefreshIndicator(
                            onRefresh: _reload,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (n) {
                                if (n.metrics.pixels > n.metrics.maxScrollExtent - 200) _loadMore();
                                return false;
                              },
                              child: ListView.separated(
                                padding: AppSpacing.page,
                                itemCount: _users.length + (_cursor != null ? 1 : 0),
                                separatorBuilder: (_, _) => const Divider(),
                                itemBuilder: (context, i) {
                                  if (i >= _users.length) {
                                    return const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: Center(child: CircularProgressIndicator()));
                                  }
                                  final u = _users[i];
                                  return AppListTile(
                                    leading: CircleAvatar(child: Text(u.fullName.isEmpty ? '?' : u.fullName.characters.first.toUpperCase())),
                                    title: u.fullName,
                                    subtitle: '${u.email}${u.phone != null ? ' · ${u.phone}' : ''} · joined ${formatDate(u.createdAt)}',
                                    trailing: Wrap(
                                      spacing: AppSpacing.xs,
                                      children: [
                                        for (final r in u.roles)
                                          StatusChip(label: titleCase(r.json), dense: true, tone: r == UserRole.admin ? StatusTone.primary : StatusTone.neutral),
                                        if (u.status == UserStatus.suspended) const StatusChip(label: 'Suspended', dense: true, tone: StatusTone.danger),
                                      ],
                                    ),
                                    showChevron: false,
                                    onTap: () => showDialog<void>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(u.fullName),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DetailRow(label: 'Email', value: u.email),
                                            DetailRow(label: 'Phone', value: u.phone ?? '—'),
                                            DetailRow(label: 'Roles', value: u.roles.map((r) => titleCase(r.json)).join(', ')),
                                            DetailRow(label: 'Vendor', value: u.vendorId ?? '—'),
                                            DetailRow(label: 'Status', value: titleCase(u.status.json)),
                                            DetailRow(label: 'User id', value: u.id),
                                          ],
                                        ),
                                        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
          ),
          if (_loading && _users.isNotEmpty) LinearProgressIndicator(minHeight: 2, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
