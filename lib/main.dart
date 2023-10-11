import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncia/services/open_ai_service.dart';
import 'app.dart';

Future<void> main() async {
  await dotenv
      .load(fileName: ".env")
      .then((_) => OpenAI.apiKey = dotenv.env['API_KEY']!);
  await OpenAiService.init();
  runApp(MyApp());
}
