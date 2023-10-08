import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncia/pages/home.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env").then(
      (_) => OpenAI.apiKey = dotenv.env['API_KEY']!
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.blue,
      theme: ThemeData(useMaterial3: true,buttonTheme: const ButtonThemeData(buttonColor: Colors.blue,)),
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        HomePage.id :(context) => const HomePage(),
      },
    );
  }
}
