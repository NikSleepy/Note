import 'package:flutter/material.dart';
import 'package:notenih/database_helper.dart';
import 'package:notenih/home_page.dart';
import 'package:notenih/note_models.dart';

class EditNotePage extends StatefulWidget {
  final NoteModel note;

  const EditNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final DatabaseHelper databaseInstance = DatabaseHelper();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.note.subject ?? '';
    _contentController.text = widget.note.content ?? '';
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() async {
    Map<String, dynamic> updatedNote = {
      'id': widget.note.id,
      'subject': _subjectController.text,
      'content': _contentController.text,
      'date': DateTime.now().toString(),
    };

    int rowsAffected = await databaseInstance.updateNote(updatedNote);

    if (rowsAffected > 0) {
      // Navigator.pop(context); // Back to previous page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update note.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Content',
                alignLabelWithHint: true,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
