import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function(Map<String, dynamic>) onSave;

  const EditProductScreen({
    super.key,
    required this.product,
    required this.index,
    required this.onSave,
  });

  @override
  EditProductScreenState createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.product['productName']);
    _categoryController =
        TextEditingController(text: widget.product['category']);
    _priceController = TextEditingController(text: widget.product['price']);
    _weightController = TextEditingController(text: widget.product['weight']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Product'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.local_florist,
              ),
              const SizedBox(height: 20),

              // Category Field
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
                icon: Icons.category,
              ),
              const SizedBox(height: 20),

              // Price Field
              _buildTextField(
                controller: _priceController,
                label: 'Price (EGP)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Weight Field
              _buildTextField(
                controller: _weightController,
                label: 'Weight',
                icon: Icons.scale,
              ),
              const SizedBox(height: 40),

              // Save Button
              CustomBottom(
                text: 'Save',
                onPressed: () {
                  if (_isFormValid()) {
                    final updatedProduct = {
                      'productName': _nameController.text,
                      'category': _categoryController.text,
                      'price': _priceController.text,
                      'weight': _weightController.text,
                      'inStock': widget.product['inStock'],
                    };

                    widget.onSave(updatedProduct);
                    Navigator.pop(context);
                  } else {
                    _showErrorDialog('Please fill out all fields!');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, fontFamily: 'SYNE'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.green.shade50,
      ),
    );
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _weightController.text.isNotEmpty;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
