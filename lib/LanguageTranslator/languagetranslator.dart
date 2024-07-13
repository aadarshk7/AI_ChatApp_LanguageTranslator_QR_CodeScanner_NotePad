import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'camera_scanner.dart'; // Import the CameraScanner class

void main() {
  runApp(LanguageTranslator());
}

class LanguageTranslator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.getThemeMode(),
            home: LanguageTranslatorScreen(),
          );
        },
      ),
    );
  }
}

class LanguageTranslatorScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageTranslatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          IconButton(
            icon: Icon(themeProvider.getThemeMode() == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme(
                  themeProvider.getThemeMode() == ThemeMode.light);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 200, // Adjust the height as needed
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 200, // Adjust the height as needed
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          provider.translatedText,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyText1?.color ?? Colors.black,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            // provider.speakText(provider.translatedText);
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
            label: 'Translate', //translate
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScannerScreen()),
            );
          }
          // Handle bottom navigation tap
        },
      ),
    );
  }
}

class LanguageTranslatorProvider extends ChangeNotifier {
  final translator = GoogleTranslator();
  // final flutterTts = FlutterTts();

  List<String> languages = [
    'Arabic', 'Argentinian', 'Brazilian Portuguese', 'English', 'French', 'German', 'Indian', 'Korean', 'Nepal', 'Portuguese', 'Spanish',  // Add more languages here
  ];

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

  //
  // void speakText(String text) async {
  //   await flutterTts.setLanguage(_getLanguageCode(toLanguage));
  //   await flutterTts.speak(text);
  // }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'Arabic':
        return 'ar';
      case 'Argentinian':
        return 'es-AR';
      case 'Brazilian Portuguese':
        return 'pt-BR';
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Indian':
        return 'hi';
      case 'Korean':
        return 'ko';
      case 'Nepal':
        return 'ne';
      case 'Portuguese':
        return 'pt';
      case 'Spanish':
        return 'es';
      default:
        return 'en';  // Default to English if not found
    }
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode getThemeMode() => _themeMode;

  ThemeData getTheme() {
    if (_themeMode == ThemeMode.dark) {
      return ThemeData.dark().copyWith(
        // Customize dark theme colors and settings here
      );
    } else {
      return ThemeData.light().copyWith(
        // Customize light theme colors and settings here
      );
    }
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
