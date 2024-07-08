import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_key.dart';

class ChatbotService {
  final String apiKey;

  ChatbotService() : apiKey = GeminiAPIKEY.api_key;

  Future<String?> getResponse(String query) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text(query)];
    final response = await model.generateContent(content);

    return response.text; // Assuming response.text contains the chatbot's reply
  }
}
