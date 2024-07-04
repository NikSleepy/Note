import 'package:flutter/material.dart';
import 'package:notenih/create_page.dart';
import 'package:notenih/database_helper.dart';
import 'package:notenih/detail_note.dart';
import 'package:notenih/main.dart';
import 'package:notenih/note_models.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    DatabaseHelper databaseInstance = DatabaseHelper();
    List<NoteModel> fetchedNotes = await databaseInstance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  void _goToCreateNotePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNotePage()),
    ).then((_) => _fetchNotes());
  }

  void _navigateToDetail(NoteModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    ).then((_) => _fetchNotes());
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Apps'),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              themeNotifier
                  .toggleTheme(); // Toggle theme when lightbulb icon is pressed
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                notes[index].subject ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'see detail',
                style: TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _navigateToDetail(notes[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateNotePage,
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 10, 166, 238),
      ),
    );
  }
}
