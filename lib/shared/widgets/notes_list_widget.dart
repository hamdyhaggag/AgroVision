import 'package:agro_vision/features/home/Ui/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../core/routing/app_routes.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Iconsax.note_text, size: 25, color: Colors.grey[800]),
                  const SizedBox(width: 12),
                  Text(
                    'Field Notes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Syne',
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                icon: Icon(Icons.arrow_forward,
                    size: 18, color: Colors.grey[600]),
                label: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Syne',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.seeAllNotes,
                  arguments: {
                    'notes': notes,
                    'onAddNote': onAddNote,
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 2),
            itemBuilder: (context, index) {
              final note = notes[index];
              return Container(
                width: 260,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AnimatedNoteCard(
                  note: note,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesScreen(
                        notes: notes,
                        onAddNote: onAddNote,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AnimatedNoteCard extends StatelessWidget {
  final Map<String, String> note;
  final VoidCallback onTap;

  const AnimatedNoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primaryContainer.withValues(alpha: 0.8),
                colors.primary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  note['image']!,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      note['content']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Flexible(
                          child: _buildInfoChip(
                            icon: Icons.calendar_today,
                            text: _formatDate(note['date']!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: _buildInfoChip(
                            icon: Icons.location_pin,
                            text: _abbreviateLocation(note['location']),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime parsed = DateTime.parse(date);
      return DateFormat('MMM d').format(parsed);
    } catch (e) {
      return date;
    }
  }

  String _abbreviateLocation(String? location) {
    return location?.replaceAll(' Field', '') ?? 'Main';
  }
}
