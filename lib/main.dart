import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> main() async {
  await dotenv
      .load(fileName: ".env")
      .then((_) => OpenAI.apiKey = dotenv.env['API_KEY']!);
  runApp(MyApp());
}

