// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:baterfly/app/features/admin/pages/products/controllers/product_controllers.dart';
import 'package:baterfly/app/features/admin/pages/products/widgets/product_form.dart';
import 'package:baterfly/app/features/admin/pages/products/widgets/product_header_bar.dart';
import 'package:baterfly/app/features/admin/pages/products/widgets/product_images.dart';
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

  bool _creating = false;

  // Controllers
  final c = ProductControllers();

  final List<String> availableImages = const [
    'assets/images/image_1.jpg',
    'assets/images/image_2.jpg',
    'assets/images/image_3.jpg',
    'assets/images/image_4.jpg',
  ];

  List<String> selectedImages = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.getActiveProducts();
      setState(() {
        _products = list;
        if (list.isNotEmpty) selectProduct(list.first);
      });
    } catch (e) {
      _error = e.toString();
    }

    setState(() => _loading = false);
  }

  void selectProduct(ProductModel p) {
    _creating = false;
    _selected = p;

    c.fillFromProduct(p);
    selectedImages = List<String>.from(p.images);
  }

  void startNewEmpty() {
    _creating = true;
    _selected = null;
    c.clearAll();
    selectedImages = [];
    setState(() {});
  }

  void startCopy() {
    if (_selected == null) return;

    _creating = true;
    _selected = null;

    c.copyFromExisting();
    selectedImages = List<String>.from(selectedImages);

    setState(() {});
  }

  Future<void> save() async {
    setState(() => _saving = true);

    try {
      final model = c.buildProduct(
        id: _creating
            ? null
            : (_selected?.id == null ? null : int.tryParse(_selected!.id!)),
        images: selectedImages,
        base: _selected,
      );

      if (_creating || _selected == null) {
        final created = await _service.createProduct(model);
        _products.add(created);
        selectProduct(created);
      } else {
        await _service.updateProduct(model);
        final idx = _products.indexWhere((e) => e.id == model.id);
        if (idx != -1) _products[idx] = model;
        selectProduct(model);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_creating ? 'تم إضافة المنتج' : 'تم حفظ المنتج'),
        ),
      );
    } catch (e) {
      _error = e.toString();
    }

    setState(() {
      _saving = false;
      _creating = false;
    });
  }

  Future<void> deleteProduct() async {
    if (_selected == null || _selected!.id == null) return;

    await _service.deleteProduct(_selected!.id!);

    _products.removeWhere((p) => p.id == _selected!.id);

    if (_products.isNotEmpty) {
      selectProduct(_products.first);
    } else {
      startNewEmpty();
    }

    setState(() {});
  }

  void toggleImage(String path) {
    setState(() {
      selectedImages.contains(path)
          ? selectedImages.remove(path)
          : selectedImages.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Text('خطأ: $_error', style: TextStyle(color: Colors.red)),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          ProductHeaderBar(
            products: _products,
            selected: _selected,
            saving: _saving,
            onSelect: selectProduct,
            onNew: startNewEmpty,
            onCopy: startCopy,
            onDelete: deleteProduct,
            onSave: save,
          ),

          const SizedBox(height: 12),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadProducts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: isMobile
                    ? Column(
                        children: [
                          ProductForm(c: c),
                          const SizedBox(height: 20),
                          ProductImages(
                            available: availableImages,
                            selected: selectedImages,
                            onToggle: toggleImage,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: ProductForm(c: c)),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: ProductImages(
                              available: availableImages,
                              selected: selectedImages,
                              onToggle: toggleImage,
                            ),
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
