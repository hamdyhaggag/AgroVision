import 'package:agro_vision/shared/widgets/custom_botton.dart';
import 'package:flutter/material.dart';

class NotesListWidget extends StatelessWidget {
  final List<Map<String, String>> notes;
  final VoidCallback onAddNote;

  const NotesListWidget({
    super.key,
    required this.notes,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Notes",
            style: TextStyle(
                fontSize: 18, fontFamily: 'Syne', fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              leading: Image.asset(note['image']!),
              title: Text(note['date']!),
              subtitle: Text(note['content']!),
            );
          },
        ),
        const SizedBox(height: 10),
        Center(
            child: CustomBottom(
          text: 'Add New Note',
          onPressed: onAddNote,
        )),
      ],
    );
  }
}
