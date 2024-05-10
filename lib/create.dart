import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
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

    // Buat objek yang akan dikirim ke API
    Map<String, dynamic> requestBody = {
      'subject': subject,
      'content': content,
    };

    // Kirim permintaan POST ke API
    var url = Uri.parse('https://example.com/api/notes');
    var response = await http.post(
      url,
      body: requestBody,
    );

    // Periksa respon dari API
    if (response.statusCode == 200) {
      // Jika berhasil, kembali ke halaman sebelumnya atau halaman utama
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      // Jika gagal, tampilkan pesan kesalahan kepada pengguna
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to save note to server.'),
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
        title: const Text('Create New Note'),
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
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
