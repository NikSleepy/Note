import 'package:flutter/material.dart';
import 'package:notenih/database_helper.dart';
import 'package:notenih/note_models.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({Key? key}) : super(key: key);

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
  String subject = _subjectController.text;
  String content = _contentController.text;

  if (subject.isEmpty || content.isEmpty) {
    _showMessage('Subject and content cannot be empty');
    return;
  }

  NoteModel newNote = NoteModel(
    subject: subject,
    content: content,
    date: DateTime.now().toString(),
  );

  int result = await databaseHelper.insertNote(newNote);

  if (result != 0) {
    _showMessage('Note saved successfully');
    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menyimpan
  } else {
    _showMessage('Failed to save note');
  }
}

void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Durasi snackbar ditampilkan
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Note'),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
              ),
            ),
            const SizedBox(height: 30),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        child: const Icon(
          Icons.save,
          semanticLabel: 'Save',
        ),
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
      ),
    );
  }
}
