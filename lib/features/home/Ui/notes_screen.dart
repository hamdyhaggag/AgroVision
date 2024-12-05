import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notes_outlined,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No notes available.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding your notes now!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Handle tap on the card (e.g., open note details)
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withOpacity(0.2),
                            AppColors.primaryColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: note['image']?.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  note['image']!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.note_alt,
                                size: 50,
                                color: AppColors.primaryColor,
                              ),
                        title: Text(
                          note['date'] ?? 'No Date',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 16),
                        ),
                        subtitle: Text(
                          note['content'] ?? 'No Content',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.black54,
                                  overflow: TextOverflow.ellipsis),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            // Handle edit action (e.g., navigate to edit screen)
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
