import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpeechToTextService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String envUrl = dotenv.env['URL'] ?? '';
  late String url;

  Future<void> loadDotenv() async {
    await dotenv.load();
    url = '$envUrl/v1/recognize?model=fr-FR';
  }

  Future<String> speechToText(String filePath) async {
    try {
      // Use File to read the audio file
      File audioFile = File(filePath);
      Uint8List audioBytes = await audioFile.readAsBytes();

      // Send the audio bytes to the API
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'audio/flac; charset=UTF-8',
          // Ensure the format matches your recording
          'Authorization':
          'Basic ${base64Encode(utf8.encode('apikey:$apiKey'))}',
        },
        body: audioBytes,
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(responseBody);
        final String transcription = responseData['results'][0]['alternatives'][0]['transcript'];
        sendCommand(transcription);
        return transcription;
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}, Response: ${response.body}');
        }
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }

  Future<void> sendCommand(String transcription) async {
    final url = dotenv.env['ROUTE_URL'] ?? '';

    try {
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'transcription': transcription}),
      );
    } catch (error) {
      if (kDebugMode) {
        print('Erreur de connexion: $error');
      }
    }
  }
}