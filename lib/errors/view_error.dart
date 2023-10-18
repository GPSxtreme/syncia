import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewErrorPage extends StatelessWidget {
  const ViewErrorPage({super.key});
  @override
  Widget build(BuildContext context) {
    final String log = Get.arguments['log'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error log'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: SelectableText(
          log,
        ),
      ),
    );
  }
}
