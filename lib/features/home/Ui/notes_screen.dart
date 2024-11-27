import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_appbar.dart';

class NotesScreen extends StatelessWidget {
  final List<Map<String, String>> notes;

  const NotesScreen({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Notes',
      ),
      body: notes.isEmpty
          ? Center(
              child: Text(
                'No notes available.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                        note['image'] ?? ''), // Add a fallback value
                    title:
                        Text(note['date'] ?? 'No Date'), // Add fallback value
                    subtitle: Text(
                        note['content'] ?? 'No Content'), // Add fallback value
                  ),
                );
              },
            ),
    );
  }
}
