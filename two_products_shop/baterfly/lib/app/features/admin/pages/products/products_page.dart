import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/product_model.dart';
import 'package:baterfly/app/services/supabase/Product_Service.dart';

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

  Future<void> _save() async {
    if (_selected == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;

      final updated = ProductModel(
        id: _selected!.id,
        slug: _slugCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        type: _typeCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: price,
        avgRating: _selected!.avgRating,
        reviewsCount: _selected!.reviewsCount,
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
        features: _selected!.features,
        usageText: _selected!.usageText,
      );

      await _service.updateProduct(updated);

      // حدّث النسخة الموجودة في القائمة
      final idx = _products.indexWhere((p) => p.id == updated.id);
      if (idx != -1) {
        _products[idx] = updated;
      }
      _setSelected(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ بيانات المنتج بنجاح'),
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
        });
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

    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد منتجات في قاعدة البيانات',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الشريط العلوي: اختيار المنتج + زر الحفظ
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
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('حفظ التعديلات'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عمود النصوص الأساسية
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildTextField(_nameCtrl, 'اسم المنتج'),
                        const SizedBox(height: 10),
                        _buildTextField(_slugCtrl, 'Slug (عنوان الرابط)'),
                        const SizedBox(height: 10),
                        _buildTextField(_typeCtrl, 'نوع / وصف قصير'),
                        const SizedBox(height: 10),
                        _buildTextField(
                          _priceCtrl,
                          'السعر',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(_descCtrl, 'وصف المنتج', maxLines: 4),
                        const SizedBox(height: 10),
                        _buildTextField(_countryCtrl, 'بلد المنشأ'),
                        const SizedBox(height: 10),
                        _buildTextField(_guaranteeCtrl, 'الضمان'),
                        const SizedBox(height: 20),
                        _buildMultilineListField(
                          controller: _mainBenefitsCtrl,
                          label: 'أهم المميزات (سطر لكل ميزة)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _ingredientsCtrl,
                          label: 'المكونات (سطر لكل عنصر)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _usageCtrl,
                          label: 'طريقة الاستخدام (سطر لكل خطوة)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _safetyCtrl,
                          label: 'الأمان / التحذيرات (سطر لكل نقطة)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _targetAudienceCtrl,
                          label: 'الفئة المستهدفة (سطر لكل نوع عميل)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _marketingCtrl,
                          label: 'جمل تسويقية (سطر لكل جملة)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _storageCtrl,
                          label: 'نصائح التخزين (سطر لكل نقطة)',
                        ),
                        const SizedBox(height: 10),
                        _buildMultilineListField(
                          controller: _highlightsCtrl,
                          label: 'مميزات إضافية (سطر لكل نقطة)',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // عمود الصور
                  Expanded(flex: 1, child: _buildImagesColumn()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMultilineListField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      maxLines: null,
      minLines: 3,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        hintText: 'كل سطر يمثل عنصر في القائمة.',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صور المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // الصور المختارة الآن
        SizedBox(
          height: 140,
          child: _selectedImages.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Text(
                    'لم يتم اختيار صور بعد',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final path = _selectedImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            path,
                            width: 110,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: InkWell(
                            onTap: () => _toggleImage(path),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),

        const SizedBox(height: 16),
        const Text(
          'اختيار من الصور المتاحة',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 260,
          child: GridView.builder(
            itemCount: _availableImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              final path = _availableImages[index];
              final isSelected = _selectedImages.contains(path);

              return GestureDetector(
                onTap: () => _toggleImage(path),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          width: 3,
                        ),
                        color: isSelected
                            ? Colors.black26
                            : Colors.black12.withOpacity(0),
                      ),
                    ),
                    if (isSelected)
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.lightBlueAccent,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
