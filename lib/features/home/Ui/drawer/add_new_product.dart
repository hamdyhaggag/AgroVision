import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_appbar.dart';

class AddNewProduct extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddNewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add New Product'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImageUploadSection(
                onTap: () => _handleImageUpload(context),
              ),
              const SizedBox(height: 32),
              _FormSection(
                title: 'Product Information',
                icon: Icons.info_outline_rounded,
                children: [
                  _CustomTextFormField(
                    label: 'Product Name',
                    icon: Icons.shopping_bag_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Product name required' : null,
                  ),
                  const SizedBox(height: 20),
                  _CustomTextFormField(
                    label: 'Category',
                    icon: Icons.category_outlined,
                    validator: (v) => v!.isEmpty ? 'Category required' : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _FormSection(
                title: 'Inventory Details',
                icon: Icons.inventory_2_outlined,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _CustomTextFormField(
                          label: 'Quantity (Kg)',
                          icon: Icons.scale_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v!.isEmpty ? 'Quantity required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _CustomTextFormField(
                          label: 'Price/Kg',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v!.isEmpty ? 'Price required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _CustomDropdownFormField(
                    items: ['In Stock', 'Low Stock', 'Out of Stock'],
                    label: 'Stock Status',
                    icon: Icons.assignment_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SubmitButton(
                onPressed: () => _handleFormSubmission(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleImageUpload(BuildContext context) {
    // Implement image upload logic
  }

  void _handleFormSubmission(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully'),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _ImageUploadSection extends StatelessWidget {
  final VoidCallback onTap;

  const _ImageUploadSection({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_rounded,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Tap to Upload Product Image',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontFamily: 'SYNE',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Recommended ratio: 1:1',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontFamily: 'SYNE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'SYNE',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _CustomTextFormField({
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'SYNE', fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontFamily: 'SYNE',
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, size: 22, color: Colors.grey.shade600),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(color: AppColors.primaryColor),
        errorBorder: _inputBorder(color: AppColors.errorColor),
        focusedErrorBorder: _inputBorder(color: AppColors.errorColor),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        errorStyle: const TextStyle(
          fontFamily: 'SYNE',
          fontSize: 12,
          color: AppColors.errorColor,
        ),
      ),
      validator: validator,
    );
  }

  OutlineInputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? Colors.grey.shade300,
        width: 1.5,
      ),
    );
  }
}

class _CustomDropdownFormField extends StatelessWidget {
  final List<String> items;
  final String label;
  final IconData icon;

  const _CustomDropdownFormField({
    required this.items,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: items.first,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontFamily: 'SYNE',
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, size: 22, color: Colors.grey.shade600),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(color: AppColors.primaryColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontFamily: 'SYNE',
                    fontSize: 15,
                  ),
                ),
              ))
          .toList(),
      onChanged: (value) {},
      icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      menuMaxHeight: 200,
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }

  OutlineInputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? Colors.grey.shade300,
        width: 1.5,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 4,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
      child: const Text(
        'Add Product',
        style: TextStyle(
          fontFamily: 'SYNE',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
