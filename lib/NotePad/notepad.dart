import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

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
  TextStyle _textStyle = TextStyle();

  List<String> get notes => _notes;
  String get currentNote => _currentNote;
  TextStyle get textStyle => _textStyle;

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

  void setBold() {
    if (_textStyle.fontWeight == FontWeight.bold) {
      _textStyle = _textStyle.copyWith(fontWeight: FontWeight.normal);
    } else {
      _textStyle = _textStyle.copyWith(fontWeight: FontWeight.bold);
    }
    notifyListeners();
  }

  void setItalic() {
    if (_textStyle.fontStyle == FontStyle.italic) {
      _textStyle = _textStyle.copyWith(fontStyle: FontStyle.normal);
    } else {
      _textStyle = _textStyle.copyWith(fontStyle: FontStyle.italic);
    }
    notifyListeners();
  }

  void setUnderline() {
    if (_textStyle.decoration == TextDecoration.underline) {
      _textStyle = _textStyle.copyWith(decoration: TextDecoration.none);
    } else {
      _textStyle = _textStyle.copyWith(decoration: TextDecoration.underline);
    }
    notifyListeners();
  }

  void undo() {
    // Implement undo functionality
  }

  Future<void> saveNote() async {
    if (_currentNote.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/note_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(path);
      await file.writeAsString(_currentNote);
      _notes.add(_currentNote);
      _currentNote = '';
      notifyListeners();
    }
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
              provider.saveNote();
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/user.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                style: provider.textStyle,
                decoration: InputDecoration(
                  hintText: 'Type something here ...',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(Icons.undo), onPressed: () {
                    provider.undo();
                  }),
                  IconButton(icon: Icon(Icons.format_bold), onPressed: () {
                    provider.setBold();
                  }),
                  IconButton(icon: Icon(Icons.format_italic), onPressed: () {
                    provider.setItalic();
                  }),
                  IconButton(icon: Icon(Icons.format_underline), onPressed: () {
                    provider.setUnderline();
                  }),
                  IconButton(icon: Icon(Icons.color_lens), onPressed: () {
                    // Implement color picker
                  }),
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
      ),
    );
  }
}
