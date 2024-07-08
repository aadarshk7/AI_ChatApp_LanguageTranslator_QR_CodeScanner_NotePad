import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  late SharedPreferences _prefs;

  ChatProvider() {
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadChatHistory();
  }

  List<Map<String, String>> get messages => _messages;

  void _loadChatHistory() {
    final history = _prefs.getStringList('chat_history');
    if (history != null) {
      _messages.addAll(history.map((msg) => jsonDecode(msg) as Map<String, String>).toList());
      notifyListeners();
    }
  }

  void _saveMessageToSharedPreferences(Map<String, String> message) {
    _messages.add(message);
    final List<String> history = _messages.map((msg) => jsonEncode(msg)).toList();
    _prefs.setStringList('chat_history', history);
    notifyListeners();
  }

  void sendMessage(String message) {
    final newMessage = {'user': message};
    _saveMessageToSharedPreferences(newMessage);

    // Simulate bot response (for demo)
    final botResponse = {'bot': 'Hello from the bot!'}; // Replace with actual bot response
    _saveMessageToSharedPreferences(botResponse);
  }
}
