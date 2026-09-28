import 'package:core_models/core_models.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/errors.dart';
import '../../../core/widgets/app_page.dart';
import '../data/admin_repository.dart';

class AdminCategoriesScreen extends ConsumerStatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  ConsumerState<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends ConsumerState<AdminCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  Future<void> _refresh() async {
    try {
      await ref.read(adminRepositoryProvider).refreshCategories();
    } catch (_) {
      await refreshCollections(ref, const [Collections.categories]);
    }
  }

  Future<void> _edit(List<Category> all, [Category? existing]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _CategoryDialog(all: all, existing: existing),
    );
    if (saved == true && mounted) showSnack(context, existing == null ? 'Category created' : 'Category updated');
  }

  Future<void> _delete(Category c) async {
    final ok = await AppBottomSheet.confirm(context,
        title: 'Delete ${c.name}?', message: 'Products keep working; they simply lose this category.', confirmLabel: 'Delete', destructive: true);
    if (!ok) return;
    try {
      await ref.read(adminRepositoryProvider).deleteCategory(c.id);
      if (mounted) showSnack(context, 'Category deleted');
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesStreamProvider);
    final online = ref.watch(isOnlineProvider);
    final api = ref.watch(apiClientProvider);
    final theme = Theme.of(context);
    final all = categories.value ?? const <Category>[];
    return AppPage(
      title: 'Categories',
      actions: [IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded), onPressed: _refresh)],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'new-category',
        onPressed: online ? () => _edit(all) : null,
        tooltip: online ? 'New category' : 'You are offline',
        icon: const Icon(Icons.add_rounded),
        label: const Text('New category'),
      ),
      body: categories.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorState(message: errorMessage(e), onRetry: _refresh),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(icon: Icons.category_outlined, title: 'No categories yet', message: 'Create top-level categories first, then nest sub-categories under them.');
          }
          final byParent = <String?, List<Category>>{};
          for (final c in list) {
            byParent.putIfAbsent(c.parentId, () => []).add(c);
          }
          for (final l in byParent.values) {
            l.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          }
          final rows = <(Category, int)>[];
          void walk(String? parent, int depth) {
            for (final c in byParent[parent] ?? const <Category>[]) {
              rows.add((c, depth));
              if (depth < 4) walk(c.id, depth + 1);
            }
          }

          walk(null, 0);
          // Orphans (parent missing) at the end.
          final seen = rows.map((r) => r.$1.id).toSet();
          for (final c in list.where((c) => !seen.contains(c.id))) {
            rows.add((c, 0));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, i) {
                final (c, depth) = rows[i];
                return Padding(
                  padding: EdgeInsets.only(left: depth * AppSpacing.xl),
                  child: AppListTile(
                    leading: c.imageId != null
                        ? AppImage(url: api.catalog.imageUrl(c.imageId!, thumb: true), width: 44, height: 44)
                        : Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: AppRadius.smAll),
                            child: Icon(depth == 0 ? Icons.category_outlined : Icons.subdirectory_arrow_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                          ),
                    title: c.name,
                    subtitle: '/${c.slug} · order ${c.sortOrder}',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(tooltip: 'Edit', icon: const Icon(Icons.edit_outlined), onPressed: online ? () => _edit(list, c) : null),
                        IconButton(tooltip: 'Delete', icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error), onPressed: online ? () => _delete(c) : null),
                      ],
                    ),
                    showChevron: false,
                    onTap: online ? () => _edit(list, c) : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryDialog extends ConsumerStatefulWidget {
  const _CategoryDialog({required this.all, this.existing});
  final List<Category> all;
  final Category? existing;

  @override
  ConsumerState<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<_CategoryDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _slug = TextEditingController(text: widget.existing?.slug ?? '');
  late final _sort = TextEditingController(text: (widget.existing?.sortOrder ?? 0).toString());
  late final _image = TextEditingController(text: widget.existing?.imageId ?? '');
  late String? _parentId = widget.existing?.parentId;
  bool _slugTouched = false;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _slug, _sort, _image]) {
      c.dispose();
    }
    super.dispose();
  }

  static String slugify(String s) => s.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final input = CategoryInput(
      name: _name.text.trim(),
      slug: _slug.text.trim().isEmpty ? slugify(_name.text) : _slug.text.trim(),
      parentId: _parentId,
      sortOrder: int.tryParse(_sort.text.trim()) ?? 0,
      imageId: _image.text.trim().isEmpty ? null : _image.text.trim(),
    );
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (widget.existing == null) {
        await repo.createCategory(input);
      } else {
        await repo.updateCategory(widget.existing!.id, input);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        showError(context, e);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final parents = widget.all.where((c) => c.id != widget.existing?.id && c.parentId != widget.existing?.id).toList();
    return AlertDialog(
      title: Text(widget.existing == null ? 'New category' : 'Edit category'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _name,
                  label: 'Name',
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Name is required' : null,
                  onChanged: (v) {
                    if (!_slugTouched) _slug.text = slugify(v);
                  },
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapMd,
                AppTextField(
                  controller: _slug,
                  label: 'Slug',
                  onChanged: (_) => _slugTouched = true,
                  validator: (v) => RegExp(r'^[a-z0-9-]*$').hasMatch((v ?? '').trim()) ? null : 'Lowercase letters, digits and dashes',
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapMd,
                DropdownButtonFormField<String?>(
                  initialValue: _parentId,
                  decoration: const InputDecoration(labelText: 'Parent category'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('None (top level)')),
                    for (final p in parents) DropdownMenuItem<String?>(value: p.id, child: Text(p.name)),
                  ],
                  onChanged: (v) => setState(() => _parentId = v),
                ),
                AppSpacing.gapMd,
                AppTextField(
                  controller: _sort,
                  label: 'Sort order',
                  keyboardType: TextInputType.number,
                  validator: (v) => int.tryParse((v ?? '').trim()) == null ? 'Enter a number' : null,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapMd,
                AppTextField(controller: _image, label: 'Image id (optional)', hint: 'An existing image id', onSubmitted: (_) => _save()),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        AppButton.primary(label: 'Save', onPressed: _save, loading: _busy),
      ],
    );
  }
}
