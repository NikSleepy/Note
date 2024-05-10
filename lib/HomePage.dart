import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notenih/create.dart';
import 'package:notenih/detailNote.dart';
import 'package:notenih/main.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<String> fetchedNotes = [];
      for (var note in data) {
        fetchedNotes.add(note['title']);
      }
      setState(() {
        notes = fetchedNotes;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to fetch data from server.'),
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

  void _goToCreateNotePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNotePage()),
    );
  }

  void _navigateToDetail(BuildContext context, String note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nootes'),
        ),
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2, // Menambah elevasi untuk efek bayangan
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Menambah margin
              child: ListTile(
                title: Text(
                  notes[index],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'see detail',
                  style: TextStyle(fontSize: 14),
                ),
                trailing: const Icon(
                    Icons.arrow_forward_ios), // Menambah ikon trailing
                onTap: () {
                  _navigateToDetail(context, notes[index]);
                },
              ),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .toggleTheme();
                },
                child: const Icon(Icons.brightness_4),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              child: FloatingActionButton(
                onPressed: _goToCreateNotePage,
                child: const Icon(Icons.add),
              ),
            )
          ],
        ));
  }
}
