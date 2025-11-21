// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/product_model.dart';
import 'package:baterfly/app/services/supabase/Product_Service.dart';

import 'widgets/product_form_fields.dart';
import 'widgets/product_images_section.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _service = ProductService();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<ProductModel> _products = [];
  ProductModel? _selected;

  bool _creatingNew = false; // 👈 هل نحن في وضع إنشاء منتج جديد؟

  // صور متاحة للاختيار (عدّل المسارات حسب مشروعك)
  final List<String> _availableImages = const [
    'assets/images/image_1.jpg',
    'assets/images/image_2.jpg',
    'assets/images/image_3.jpg',
    'assets/images/image_4.jpg',
  ];

  // Controllers للنصوص
  final _nameCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _guaranteeCtrl = TextEditingController();

  final _mainBenefitsCtrl = TextEditingController();
  final _ingredientsCtrl = TextEditingController();
  final _usageCtrl = TextEditingController();
  final _safetyCtrl = TextEditingController();
  final _targetAudienceCtrl = TextEditingController();
  final _marketingCtrl = TextEditingController();
  final _storageCtrl = TextEditingController();
  final _highlightsCtrl = TextEditingController();

  List<String> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _slugCtrl.dispose();
    _typeCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _countryCtrl.dispose();
    _guaranteeCtrl.dispose();
    _mainBenefitsCtrl.dispose();
    _ingredientsCtrl.dispose();
    _usageCtrl.dispose();
    _safetyCtrl.dispose();
    _targetAudienceCtrl.dispose();
    _marketingCtrl.dispose();
    _storageCtrl.dispose();
    _highlightsCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.getActiveProducts();
      setState(() {
        _products = list;
        if (list.isNotEmpty) {
          _setSelected(list.first);
        } else {
          _selected = null;
        }
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _setSelected(ProductModel product) {
    _creatingNew = false;
    _selected = product;

    _nameCtrl.text = product.name;
    _slugCtrl.text = product.slug;
    _typeCtrl.text = product.type;
    _descCtrl.text = product.description;
    _priceCtrl.text = product.price == 0
        ? ''
        : product.price.toStringAsFixed(2);
    _countryCtrl.text = product.countryOfOrigin;
    _guaranteeCtrl.text = product.guarantee;

    _mainBenefitsCtrl.text = product.mainBenefits.join('\n');
    _ingredientsCtrl.text = product.ingredients.join('\n');
    _usageCtrl.text = product.usage.join('\n');
    _safetyCtrl.text = product.safety.join('\n');
    _targetAudienceCtrl.text = product.targetAudience.join('\n');
    _marketingCtrl.text = product.marketingPhrases.join('\n');
    _storageCtrl.text = product.storageTips.join('\n');
    _highlightsCtrl.text = product.highlights.join('\n');

    _selectedImages = List<String>.from(product.images);
  }

  List<String> _splitLines(String text) {
    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _startNewFromCurrent() {
    setState(() {
      _creatingNew = true;
      _selected = null;
      _nameCtrl.text = '${_nameCtrl.text} (نسخة)';
      _slugCtrl.text = '';
    });
  }

  void _startNewEmpty() {
    setState(() {
      _creatingNew = true;
      _selected = null;

      _nameCtrl.clear();
      _slugCtrl.clear();
      _typeCtrl.clear();
      _descCtrl.clear();
      _priceCtrl.clear();
      _countryCtrl.clear();
      _guaranteeCtrl.clear();

      _mainBenefitsCtrl.clear();
      _ingredientsCtrl.clear();
      _usageCtrl.clear();
      _safetyCtrl.clear();
      _targetAudienceCtrl.clear();
      _marketingCtrl.clear();
      _storageCtrl.clear();
      _highlightsCtrl.clear();

      _selectedImages = [];
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
      final isCreate = _creatingNew || _selected == null;

      final model = ProductModel(
        id: isCreate ? null : _selected!.id,
        slug: _slugCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        type: _typeCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: price,
        avgRating: isCreate ? 0 : _selected!.avgRating,
        reviewsCount: isCreate ? 0 : _selected!.reviewsCount,
        images: _selectedImages,
        mainBenefits: _splitLines(_mainBenefitsCtrl.text),
        ingredients: _splitLines(_ingredientsCtrl.text),
        usage: _splitLines(_usageCtrl.text),
        safety: _splitLines(_safetyCtrl.text),
        targetAudience: _splitLines(_targetAudienceCtrl.text),
        countryOfOrigin: _countryCtrl.text.trim(),
        guarantee: _guaranteeCtrl.text.trim(),
        marketingPhrases: _splitLines(_marketingCtrl.text),
        storageTips: _splitLines(_storageCtrl.text),
        highlights: _splitLines(_highlightsCtrl.text),
        features: isCreate ? const [] : _selected!.features,
        usageText: isCreate ? '' : _selected!.usageText,
      );

      if (isCreate) {
        // INSERT
        final created = await _service.createProduct(model);
        setState(() {
          _products.add(created);
          _setSelected(created);
        });
      } else {
        // UPDATE
        await _service.updateProduct(model);
        final idx = _products.indexWhere((p) => p.id == model.id);
        if (idx != -1) {
          _products[idx] = model;
        }
        _setSelected(model);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCreate ? 'تم إنشاء المنتج بنجاح' : 'تم حفظ بيانات المنتج بنجاح',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _creatingNew = false;
        });
      }
    }
  }

  Future<void> _deleteSelected() async {
    if (_selected == null || _selected!.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text(
          'هل أنت متأكد من حذف المنتج "${_selected!.name}"؟\n'
          'لا يمكن التراجع عن هذه العملية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _saving = true);

    try {
      await _service.deleteProduct(_selected!.id!);
      setState(() {
        _products.removeWhere((p) => p.id == _selected!.id);
        if (_products.isNotEmpty) {
          _setSelected(_products.first);
        } else {
          _startNewEmpty();
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ أثناء الحذف: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _toggleImage(String path) {
    setState(() {
      if (_selectedImages.contains(path)) {
        _selectedImages.remove(path);
      } else {
        _selectedImages.add(path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text('خطأ: $_error', style: const TextStyle(color: Colors.red)),
      );
    }

    if (_products.isEmpty && !_creatingNew) {
      // لا يوجد منتجات، نبدأ مباشرة في إنشاء منتج جديد
      _startNewEmpty();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          final mainContent = isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductFormFields(
                      nameCtrl: _nameCtrl,
                      slugCtrl: _slugCtrl,
                      typeCtrl: _typeCtrl,
                      priceCtrl: _priceCtrl,
                      descCtrl: _descCtrl,
                      countryCtrl: _countryCtrl,
                      guaranteeCtrl: _guaranteeCtrl,
                      mainBenefitsCtrl: _mainBenefitsCtrl,
                      ingredientsCtrl: _ingredientsCtrl,
                      usageCtrl: _usageCtrl,
                      safetyCtrl: _safetyCtrl,
                      targetAudienceCtrl: _targetAudienceCtrl,
                      marketingCtrl: _marketingCtrl,
                      storageCtrl: _storageCtrl,
                      highlightsCtrl: _highlightsCtrl,
                    ),
                    const SizedBox(height: 16),
                    ProductImagesSection(
                      availableImages: _availableImages,
                      selectedImages: _selectedImages,
                      onToggle: _toggleImage,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ProductFormFields(
                        nameCtrl: _nameCtrl,
                        slugCtrl: _slugCtrl,
                        typeCtrl: _typeCtrl,
                        priceCtrl: _priceCtrl,
                        descCtrl: _descCtrl,
                        countryCtrl: _countryCtrl,
                        guaranteeCtrl: _guaranteeCtrl,
                        mainBenefitsCtrl: _mainBenefitsCtrl,
                        ingredientsCtrl: _ingredientsCtrl,
                        usageCtrl: _usageCtrl,
                        safetyCtrl: _safetyCtrl,
                        targetAudienceCtrl: _targetAudienceCtrl,
                        marketingCtrl: _marketingCtrl,
                        storageCtrl: _storageCtrl,
                        highlightsCtrl: _highlightsCtrl,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // عمود الصور
                    Expanded(
                      flex: 1,
                      child: ProductImagesSection(
                        availableImages: _availableImages,
                        selectedImages: _selectedImages,
                        onToggle: _toggleImage,
                      ),
                    ),
                  ],
                );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<ProductModel>(
                      value: _selected,
                      decoration: const InputDecoration(
                        labelText: 'اختر المنتج',
                        border: OutlineInputBorder(),
                      ),
                      items: _products
                          .map(
                            (p) => DropdownMenuItem<ProductModel>(
                              value: p,
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                      onChanged: (p) {
                        if (p != null) {
                          setState(() {
                            _setSelected(p);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // منتج جديد فارغ
                  TextButton.icon(
                    onPressed: _saving ? null : _startNewEmpty,
                    icon: const Icon(Icons.add),
                    label: const Text('منتج جديد'),
                  ),
                  const SizedBox(width: 8),
                  // نسخ كمنتج جديد
                  TextButton.icon(
                    onPressed: _saving || _selected == null
                        ? null
                        : _startNewFromCurrent,
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ كمنتج جديد'),
                  ),
                  const SizedBox(width: 8),
                  // حذف المنتج الحالي
                  TextButton.icon(
                    onPressed: _saving || _selected == null
                        ? null
                        : _deleteSelected,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'حذف',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // حفظ
                  ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('حفظ'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: mainContent,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
