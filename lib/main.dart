import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncia/pages/home.dart';

Future<void> main() async {
  await dotenv
      .load(fileName: ".env")
      .then((_) => OpenAI.apiKey = dotenv.env['API_KEY']!);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            backgroundColor: Colors.blue,
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
      },
    );
  }
}
