import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotepadProvider(),
      child: MaterialApp(
        title: 'Notepad',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotepadScreen(),
      ),
    );
  }
}

class NotepadProvider with ChangeNotifier {
  List<String> _notes = [];
  String _currentNote = '';

  List<String> get notes => _notes;
  String get currentNote => _currentNote;

  void addNote() {
    if (_currentNote.isNotEmpty) {
      _notes.add(_currentNote);
      _currentNote = '';
      notifyListeners();
    }
  }

  void updateCurrentNote(String note) {
    _currentNote = note;
    notifyListeners();
  }
}

class NotepadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotepadProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              provider.addNote();
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/user.png'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Note',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (text) {
                provider.updateCurrentNote(text);
              },
              decoration: InputDecoration(
                hintText: 'Type something here ...',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.undo), onPressed: () {}),
                IconButton(icon: Icon(Icons.format_bold), onPressed: () {}),
                IconButton(icon: Icon(Icons.format_italic), onPressed: () {}),
                IconButton(icon: Icon(Icons.format_underline), onPressed: () {}),
                IconButton(icon: Icon(Icons.color_lens), onPressed: () {}),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'TODAY - ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
