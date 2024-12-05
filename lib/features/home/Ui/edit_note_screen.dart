import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_botton.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String currentContent;

  const EditNoteScreen({
    super.key,
    required this.noteId,
    required this.currentContent,
  });

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() {
    final updatedContent = _controller.text;

    if (kDebugMode) {
      print('Note ID: ${widget.noteId}, Updated Content: $updatedContent');
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Note'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              cursorColor: AppColors.primaryColor,
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Edit your note',
                labelStyle: TextStyle(
                  fontFamily: 'SYNE',
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2.0), // Set primary color on focus
                ),
                focusColor: AppColors.primaryColor,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            CustomBottom(
              text: 'Save',
              onPressed: _saveNote,
            ),
          ],
        ),
      ),
    );
  }
}
