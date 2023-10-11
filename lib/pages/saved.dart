import 'package:flutter/material.dart';
import 'package:syncia/widgets/app_drawer.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Saved'),
      ),
    );
  }
}
