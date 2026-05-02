import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../data/repositories/category_repository.dart';
import '../../data/database/database.dart';
import '../shared/app_theme.dart';

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends ConsumerState<CategoryManagementScreen> {
  List<Category> _mainCategories = [];
  Map<int, List<Category>> _subcategoriesMap = {};
  Set<int> _expandedCategories = {};
  bool _isLoading = true;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(categoryRepositoryProvider);
      await repo.initializeDefaultCategories().timeout(const Duration(seconds: 5), onTimeout: () => debugPrint('Timeout'));
      final mainCats = await repo.getMainCategories();
      final subsMap = <int, List<Category>>{};
      for (final cat in mainCats) {
        subsMap[cat.id] = await repo.getSubcategories(cat.id);
      }
      if (mounted) {
        setState(() {
          _mainCategories = mainCats;
          _subcategoriesMap = subsMap;
          _isLoading = false;
          if (mainCats.isNotEmpty && _expandedCategories.isEmpty) {
            _expandedCategories.add(mainCats.first.id);
            _selectedCategoryId = mainCats.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
      if (image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final dir = Directory(p.join(appDir.path, 'category_images'));
        if (!await dir.exists()) await dir.create(recursive: true);
        final path = p.join(dir.path, 'cat_${DateTime.now().millisecondsSinceEpoch}.png');
        await File(image.path).copy(path);
        return path;
      }
    } catch (e) {}
    return null;
  }

  void _showCategoryDialog({Category? category, Category? parent, bool isSub = false}) {
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    String? img = category?.imageUrl;
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.r20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isSub ? AppTheme.primaryButtonGradient : AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(AppTheme.r12),
                ),
                child: Icon(isSub ? Icons.subdirectory_arrow_right_rounded : Icons.category_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category != null ? 'Edit ${isSub ? "Sub" : "Main"}' : 'New ${isSub ? "Sub" : "Main"}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    if (parent != null) Text('Under ${parent.name}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final path = await _pickImage();
                    if (path != null) setS(() => img = path);
                  },
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r16), border: Border.all(color: AppTheme.border, width: 2),
                      image: img != null ? DecorationImage(image: FileImage(File(img!)), fit: BoxFit.cover) : null),
                    child: img == null ? const Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppTheme.textMuted) : null,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Display Name', prefixIcon: const Icon(Icons.label_rounded))),
                const SizedBox(height: 16),
                TextField(controller: descCtrl, decoration: InputDecoration(labelText: 'Description (Optional)', prefixIcon: const Icon(Icons.description_rounded)), maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty) return;
                final repo = ref.read(categoryRepositoryProvider);
                if (category != null) await repo.updateCategory(id: category.id, name: nameCtrl.text, description: descCtrl.text, imageUrl: img);
                else await repo.addCategory(name: nameCtrl.text, parentId: parent?.id, description: descCtrl.text, imageUrl: img);
                if (ctx.mounted) Navigator.pop(ctx);
                _loadCategories();
              },
              child: const Text('SAVE CATEGORY'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDelete(Category cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to remove "${cat.name}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redDanger),
            onPressed: () async {
              await ref.read(categoryRepositoryProvider).deleteCategory(cat.id);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadCategories();
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appBackground,
      appBar: AppBar(
        title: const Text('Inventory Categories'),
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _loadCategories),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Row(
            children: [
              // Main Categories Sidebar
              Container(
                width: 320,
                decoration: const BoxDecoration(color: AppTheme.surface, border: Border(right: BorderSide(color: AppTheme.border))),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _mainCategories.length,
                  itemBuilder: (context, i) {
                    final cat = _mainCategories[i];
                    final active = _selectedCategoryId == cat.id;
                    return _buildMainCatTile(cat, active);
                  },
                ),
              ),
              // Subcategories Content
              Expanded(
                child: _selectedCategoryId == null 
                  ? const Center(child: Text('Select a category to view sub-items'))
                  : _buildSubcatContent(),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Main Category'),
        backgroundColor: AppTheme.royalBlue,
      ),
    );
  }

  Widget _buildMainCatTile(Category cat, bool active) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedCategoryId = cat.id),
        borderRadius: BorderRadius.circular(AppTheme.r12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppTheme.infoSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.r12),
            border: Border.all(color: active ? AppTheme.royalBlue.withValues(alpha: 0.2) : Colors.transparent),
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: active ? AppTheme.royalBlue : AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r8),
                  image: cat.imageUrl != null ? DecorationImage(image: FileImage(File(cat.imageUrl!)), fit: BoxFit.cover) : null),
                child: cat.imageUrl == null ? Icon(Icons.folder_rounded, color: active ? Colors.white : AppTheme.textMuted, size: 20) : null,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(cat.name, style: TextStyle(fontWeight: active ? FontWeight.w800 : FontWeight.w600, color: active ? AppTheme.royalBlue : AppTheme.textPrimary))),
              if (active) const Icon(Icons.chevron_right_rounded, color: AppTheme.royalBlue, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcatContent() {
    final cat = _mainCategories.firstWhere((c) => c.id == _selectedCategoryId);
    final subs = _subcategoriesMap[cat.id] ?? [];
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cat.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    Text('${subs.length} Subcategories defined', style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
                const Spacer(),
                OutlinedButton.icon(icon: const Icon(Icons.edit_rounded, size: 18), label: const Text('Edit Main'), onPressed: () => _showCategoryDialog(category: cat)),
                const SizedBox(width: 12),
                ElevatedButton.icon(icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Add Sub'), onPressed: () => _showCategoryDialog(parent: cat, isSub: true)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 2.5),
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildSubcatCard(subs[i], cat),
              childCount: subs.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubcatCard(Category sub, Category parent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(AppTheme.r16), border: Border.all(color: AppTheme.border), boxShadow: AppTheme.softShadow),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(AppTheme.r12),
              image: sub.imageUrl != null ? DecorationImage(image: FileImage(File(sub.imageUrl!)), fit: BoxFit.cover) : null),
            child: sub.imageUrl == null ? const Icon(Icons.label_important_rounded, color: AppTheme.amberWarning, size: 24) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sub.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                if (sub.description != null) Text(sub.description!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary), maxLines: 1),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (v) {
              if (v == 'edit') _showCategoryDialog(category: sub, parent: parent, isSub: true);
              else _showDelete(sub);
            },
          ),
        ],
      ),
    );
  }
}
