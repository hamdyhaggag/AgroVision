import 'package:agro_vision/features/home/Ui/notes_screen.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Notes",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Syne',
                    fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesScreen(notes: notes),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SYNE',
                ),
              ),
            )
          ],
        ),
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
          ),
        ),
      ],
    );
  }
}
