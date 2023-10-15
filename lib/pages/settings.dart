import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncia/widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(centerTitle: true, title: const Text('Settings')),
      body: Column(
        children: [
          ListTile(
            title: const Text("Open ai api key"),
            subtitle: Text(dotenv.env['API_KEY'].toString()),
          )
        ],
      ),
    );
  }
}
