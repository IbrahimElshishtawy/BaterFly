import 'package:flutter/material.dart';
import 'package:baterfly/app/data/models/product_model.dart';

class ProductHeaderBar extends StatelessWidget {
  final List<ProductModel> products;
  final ProductModel? selected;

  final bool saving;
  final Function(ProductModel) onSelect;
  final VoidCallback onNew;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const ProductHeaderBar({
    super.key,
    required this.products,
    required this.selected,
    required this.saving,
    required this.onSelect,
    required this.onNew,
    required this.onCopy,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<ProductModel>(
            value: selected,
            decoration: const InputDecoration(
              labelText: 'اختر المنتج',
              border: OutlineInputBorder(),
            ),
            items: products
                .map(
                  (p) => DropdownMenuItem<ProductModel>(
                    value: p,
                    child: Text(p.name),
                  ),
                )
                .toList(),
            onChanged: (p) {
              if (p != null) onSelect(p);
            },
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Wrap(
            spacing: 8,
            alignment: WrapAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('جديد'),
                onPressed: saving ? null : onNew,
              ),
              TextButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('نسخ'),
                onPressed: saving || selected == null ? null : onCopy,
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('حذف', style: TextStyle(color: Colors.red)),
                onPressed: saving || selected == null ? null : onDelete,
              ),
              ElevatedButton.icon(
                icon: saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('حفظ'),
                onPressed: saving ? null : onSave,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
