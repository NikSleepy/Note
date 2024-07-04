import 'package:flutter/material.dart';
import 'package:notenih/database_helper.dart';
import 'package:notenih/edit_page.dart';
import 'package:notenih/note_models.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteModel note;
  final DatabaseHelper databaseInstance = DatabaseHelper();

  NoteDetailPage({Key? key, required this.note}) : super(key: key);

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToEdit(context, note);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (note.id != null) {
                    _showDeleteConfirmation(context, note.id!);
                  } else {
                    // Handle the case where note.id is null
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Note ID is null')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToEdit(BuildContext context, NoteModel note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNotePage(note: note)),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note updated')),
      );
    });
  }

  void _showDeleteConfirmation(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                int result = await databaseInstance.deleteNote(noteId);
                Navigator.pop(context); // Close confirmation dialog
                if (result > 0) {
                  Navigator.pop(context); // Back to previous page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Note deleted successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete note')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showModal(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.subject ?? 'No Subject',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              note.content ?? 'No Content',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              note.date ?? 'No Date',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${note.id ?? 'No ID'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
