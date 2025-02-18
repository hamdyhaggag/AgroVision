import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/features/home/Ui/widgets/task_list_screen.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Logic/task_cubit/task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dueDate;
  String _priority = 'Medium';
  final int _maxNotesLength = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'New Task',
        isHome: false,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskTitleField(),
                const SizedBox(height: 28),
                _buildDatePickerField(),
                const SizedBox(height: 28),
                _buildPriorityDropdown(),
                const SizedBox(height: 28),
                _buildNotesField(),
                const SizedBox(height: 40),
                CustomBottom(
                  text: 'Create Task',
                  onPressed: _submitForm,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Task Title',
        hintText: 'Enter task name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: const Icon(Icons.short_text_rounded, size: 24),
        ),
        suffixIcon: _titleController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 20),
                onPressed: () => _titleController.clear(),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a task title';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded,
                color: Colors.grey[600], size: 22),
            const SizedBox(width: 16),
            Text(
              _dueDate == null
                  ? 'Select due date'
                  : DateFormat('MMM dd, yyyy').format(_dueDate!),
              style: TextStyle(
                fontSize: 16,
                color: _dueDate == null ? Colors.grey[400] : Colors.grey[800],
              ),
            ),
            const Spacer(),
            Text(
              _dueDate == null ? '' : DateFormat('EEEE').format(_dueDate!),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _priority,
      items: ['Low', 'Medium', 'High'].map((priority) {
        Color color;
        switch (priority) {
          case 'High':
            color = Colors.red;
            break;
          case 'Medium':
            color = Colors.orange;
            break;
          default:
            color = Colors.green;
        }
        return DropdownMenuItem(
          value: priority,
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(priority, style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _priority = value!),
      decoration: InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: const Icon(Icons.flag_rounded, size: 22),
        ),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down_rounded),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          maxLength: _maxNotesLength,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Notes',
            hintText: 'Add additional details...',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_notesController.text.length}/$_maxNotesLength',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a due date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        dueDate: _dueDate!,
        priority: _priority,
        notes: _notesController.text,
      );

      context.read<TaskCubit>().addTask(newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task created successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
          backgroundColor: AppColors.primaryColor,
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const TaskListScreen()));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
