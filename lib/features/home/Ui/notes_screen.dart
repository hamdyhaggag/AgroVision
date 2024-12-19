import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';
import 'edit_note_screen.dart';

class NotesScreen extends StatefulWidget {
  final List<Map<String, String>> notes;

  const NotesScreen({super.key, required this.notes});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Notes',
      ),
      body: widget.notes.isEmpty
          ? _buildEmptyNotesUI(context)
          : ListView.builder(
              itemCount: widget.notes.length,
              itemBuilder: (context, index) {
                final note = widget.notes[index];
                return _buildNoteCard(context, note, index);
              },
            ),
    );
  }

  Widget _buildEmptyNotesUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notes_outlined,
            size: 120,
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'No notes available.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start adding your notes now!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Action to add a new note
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(
      BuildContext context, Map<String, String> note, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailsScreen(
                note: note,
                onDelete: () => _deleteNoteAtIndex(context, index),
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.3),
                AppColors.primaryColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: _buildNoteImage(note),
            title: Text(
              note['date'] ?? 'No Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
            ),
            subtitle: Text(
              note['content'] ?? 'No Content',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            trailing: _buildNoteActions(context, note, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteImage(Map<String, String> note) {
    if (note['image']?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          note['image']!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
      child: const Icon(
        Icons.note_alt,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildNoteActions(
      BuildContext context, Map<String, String> note, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          color: AppColors.primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNoteScreen(
                  noteId: note['id'] ?? 'unknown',
                  currentContent: note['content'] ?? '',
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,
          onPressed: () => _confirmDelete(context, index),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteNoteAtIndex(context, index);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteNoteAtIndex(BuildContext context, int index) {
    setState(() {
      widget.notes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted successfully!')),
    );
  }
}

class NoteDetailsScreen extends StatelessWidget {
  final Map<String, String> note;
  final VoidCallback onDelete;

  const NoteDetailsScreen(
      {super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Note Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.primaryColor),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note['image']?.isNotEmpty == true)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    child: Image.asset(
                      note['image']!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        note['date'] ?? 'No Date',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                color: AppColors.primaryColor.withOpacity(0.1),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  note['date'] ?? 'No Date',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            const SizedBox(height: 24),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    note['content'] ?? 'No Content',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
