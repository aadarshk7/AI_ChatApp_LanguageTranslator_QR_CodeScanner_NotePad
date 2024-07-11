import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(LanguageTranslator());
}

class LanguageTranslator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageTranslatorProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LanguageTranslatorScreen(),
      ),
    );
  }
}

class LanguageTranslatorScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageTranslatorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Add history page navigation
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Add favorites page navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: provider.fromLanguage,
                  items: provider.languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    provider.setFromLanguage(newValue!);
                  },
                ),
                Icon(Icons.swap_horiz),
                DropdownButton<String>(
                  value: provider.toLanguage,
                  items: provider.languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    provider.setToLanguage(newValue!);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.fromLanguage,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Enter text to translate'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await provider.translateText(_controller.text);
                    },
                    child: Text('Translate'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.toLanguage,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(provider.translatedText),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          provider.speakText(provider.translatedText);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: provider.translatedText));
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied to Clipboard')));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.language),
            label: 'Translate',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }
}

class LanguageTranslatorProvider extends ChangeNotifier {
  final translator = GoogleTranslator();
  final flutterTts = FlutterTts();

  List<String> languages = ['English', 'Spanish', 'French', 'German', 'Nepal'];
  String fromLanguage = 'English';
  String toLanguage = 'Nepal';
  String translatedText = '';

  void setFromLanguage(String language) {
    fromLanguage = language;
    notifyListeners();
  }

  void setToLanguage(String language) {
    toLanguage = language;
    notifyListeners();
  }

  Future<void> translateText(String text) async {
    if (text.isEmpty) return;
    final translation = await translator.translate(text,
        from: _getLanguageCode(fromLanguage), to: _getLanguageCode(toLanguage));
    translatedText = translation.text;
    notifyListeners();
  }

  void speakText(String text) async {
    await flutterTts.setLanguage(_getLanguageCode(toLanguage));
    await flutterTts.speak(text);
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
        case 'Nepal':
        return 'ne';
      default:
        return 'en';
    }
  }
}
