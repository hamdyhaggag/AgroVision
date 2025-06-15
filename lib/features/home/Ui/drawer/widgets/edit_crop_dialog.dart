import 'package:flutter/material.dart';
import '../../../../../models/category_model.dart';
import '../farm_inventory.dart';

class EditCropDialog extends StatefulWidget {
  final InventoryItem item;
  final List<Category> categories;
  final Function(Map<String, dynamic>) onSave;

  const EditCropDialog({
    super.key,
    required this.item,
    required this.categories,
    required this.onSave,
  });

  @override
  _EditCropDialogState createState() => _EditCropDialogState();
}

class _EditCropDialogState extends State<EditCropDialog> {
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late String _selectedCategory;
  late String _selectedStatus;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.item.productName);
    _priceController =
        TextEditingController(text: widget.item.price.replaceAll(' EGP', ''));
    _quantityController =
        TextEditingController(text: widget.item.quantity.replaceAll(' Kg', ''));
    _selectedCategory = widget.item.category;
    _selectedStatus = _mapStatusToDisplay(widget.item.status);
  }

  String _mapStatusToDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'instock':
        return 'In Stock';
      case 'outofstock':
        return 'Out of Stock';
      case 'lowstock':
        return 'Low Stock';
      default:
        return 'In Stock';
    }
  }

  String _mapDisplayToStatus(String displayStatus) {
    switch (displayStatus) {
      case 'In Stock':
        return 'instock';
      case 'Out of Stock':
        return 'outofstock';
      case 'Low Stock':
        return 'lowstock';
      default:
        return 'instock';
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final formData = {
        'productName': _productNameController.text,
        'pricePerKilo': double.parse(_priceController.text),
        'productCategory': _selectedCategory,
        'quantity': int.parse(_quantityController.text),
        'status': _mapDisplayToStatus(_selectedStatus),
        'user_id': widget.item.userId,
      };
      final success = await widget.onSave(formData);
      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Crop', style: TextStyle(fontFamily: 'SYNE')),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per Kilo (EGP)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity (Kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories
                    .map((c) => DropdownMenuItem(
                          value: c.name,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'In Stock', child: Text('In Stock')),
                  DropdownMenuItem(
                      value: 'Low Stock', child: Text('Low Stock')),
                  DropdownMenuItem(
                      value: 'Out of Stock', child: Text('Out of Stock')),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value!),
                validator: (value) => value == null ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _saveForm,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}
