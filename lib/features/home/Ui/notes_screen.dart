import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';
import 'edit_note_screen.dart';

class NotesScreen extends StatefulWidget {
  final List<Map<String, String>> notes;
  final VoidCallback onAddNote;

  const NotesScreen({
    super.key,
    required this.notes,
    required this.onAddNote,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryColor,
      ),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'My Notes',
          isHome: true,
        ),
        floatingActionButton: _buildFloatingActionButton(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryColor, Colors.white],
            ),
          ),
          child: widget.notes.isEmpty
              ? _buildEmptyNotesUI(context)
              : _buildNotesList(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: widget.onAddNote,
      backgroundColor: AppColors.primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('New Note', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildNotesList() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 24, bottom: 100),
            itemCount: widget.notes.length,
            itemBuilder: (context, index) => _buildNoteItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(int index) {
    final note = widget.notes[index];
    final noteId = note['id'] ?? 'note_$index';
    final uniqueKey = Key('${noteId}_${note['date']}');

    return Dismissible(
      key: uniqueKey,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _confirmDelete(context, index);
      },
      background: _buildDismissibleBackground(),
      onDismissed: (_) => _deleteNoteAtIndex(context, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Hero(
          tag: noteId,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.05),
                    Colors.white
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _navigateToDetailScreen(context, note, index),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNoteHeader(note),
                      const SizedBox(height: 12),
                      _buildNoteContent(note),
                      const SizedBox(height: 8),
                      _buildNoteFooter(note),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 30),
      child: const Icon(Icons.delete_forever, color: Colors.white, size: 36),
    );
  }

  Widget _buildNoteHeader(Map<String, String> note) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            note['category']?.toUpperCase() ?? 'PERSONAL',
            style: const TextStyle(
              color: AppColors.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Spacer(),
        Text(
          note['time'] ?? '10:00 AM',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteContent(Map<String, String> note) {
    return Text(
      note['content'] ?? '',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        height: 1.4,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNoteFooter(Map<String, String> note) {
    return Row(
      children: [
        Text(
          note['date'] ?? 'Today',
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.grey[600]),
          onPressed: () => _navigateToEditScreen(context),
        ),
      ],
    );
  }

  Widget _buildEmptyNotesUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 500),
            child: Lottie.asset(
              'assets/animations/empty_notes.json',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Start Your Journey',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(2, 2),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Capture ideas, moments, and to-dos\nwith beautiful notes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailScreen(
      BuildContext context, Map<String, String> note, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => NoteDetailsScreen(
          note: note,
          onDelete: () => _deleteNoteAtIndex(context, index),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EditNoteScreen(noteId: 'new', currentContent: ''),
        fullscreenDialog: true,
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, int index) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Delete'),
        content: const Text('This note will be permanently removed'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNoteAtIndex(BuildContext context, int index) {
    final deletedNote = widget.notes[index];

    setState(() {
      widget.notes.removeAt(index);
    });

    _showDeletionSnackbar(context, deletedNote, index);
  }

  void _showDeletionSnackbar(
      BuildContext context, Map<String, String> deletedNote, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.primaryColor,
        content: const Text('Note moved to trash'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () => _undoDelete(deletedNote, index),
        ),
      ),
    );
  }

  void _undoDelete(Map<String, String> note, int index) {
    setState(() {
      widget.notes.insert(index, note);
    });
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildNoteImage(),
              stretchModes: const [StretchMode.zoomBackground],
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNoteMeta(),
                  const SizedBox(height: 24),
                  _buildNoteContent(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteImage() {
    final noteId = note['id'] ?? 'default_id';

    return Hero(
      tag: noteId,
      child: note['image']?.isNotEmpty == true
          ? Image.asset(note['image']!, fit: BoxFit.cover)
          : Container(
              color: AppColors.primaryColor,
              child: Center(
                child: Icon(Icons.note_alt,
                    size: 100, color: Colors.white.withValues(alpha: 0.3)),
              ),
            ),
    );
  }

  Widget _buildNoteMeta() {
    return Row(
      children: [
        Chip(
          backgroundColor: AppColors.accentColor.withValues(alpha: 0.2),
          label: Text(note['category']?.toUpperCase() ?? 'GENERAL',
              style: const TextStyle(
                  color: AppColors.accentColor, fontWeight: FontWeight.bold)),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(note['date'] ?? 'Today',
                style: const TextStyle(color: Colors.grey)),
            Text(note['time'] ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildNoteContent() {
    return Text(
      note['content'] ?? '',
      style: const TextStyle(fontSize: 18, height: 1.6),
    );
  }
}
