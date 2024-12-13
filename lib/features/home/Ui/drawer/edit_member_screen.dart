import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class EditMemberScreen extends StatefulWidget {
  final Map<String, dynamic> member;
  final int index;
  final Function(Map<String, dynamic>) onSave;

  const EditMemberScreen({
    super.key,
    required this.member,
    required this.index,
    required this.onSave,
  });

  @override
  EditMemberScreenState createState() => EditMemberScreenState();
}

class EditMemberScreenState extends State<EditMemberScreen> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late bool _isMale;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member['memberName']);
    _positionController =
        TextEditingController(text: widget.member['position']);
    _emailController = TextEditingController(text: widget.member['email']);
    _phoneController = TextEditingController(text: widget.member['phone']);
    _isMale = widget.member['type']; // Initialize with the provided value
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Team Member'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Member Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),

              // Position Field
              _buildTextField(
                controller: _positionController,
                label: 'Position',
                icon: Icons.work,
              ),
              const SizedBox(height: 20),

              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Phone Field
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<bool>(
                        activeColor: AppColors.primaryColor,
                        value: true,
                        groupValue: _isMale,
                        onChanged: (value) {
                          setState(() {
                            _isMale = value!;
                          });
                        },
                      ),
                      const Text('Male'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<bool>(
                        activeColor: AppColors.primaryColor,
                        value: false,
                        groupValue: _isMale,
                        onChanged: (value) {
                          setState(() {
                            _isMale = value!;
                          });
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Save Button
              CustomBottom(
                text: 'Save',
                onPressed: () {
                  if (_isFormValid()) {
                    final updatedMember = {
                      'memberName': _nameController.text,
                      'position': _positionController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'type': _isMale,
                      'image': widget.member['image'],
                    };

                    widget.onSave(updatedMember);
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
        _positionController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
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
