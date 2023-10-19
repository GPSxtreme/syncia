import 'package:flutter/material.dart';

class ObscuredTextEditingController extends TextEditingController {
  String _trueText = '';

  ObscuredTextEditingController({String text = ''}) {
    _trueText = text;
    super.text = _obscureText(text);
  }

  @override
  set text(String newText) {
    _trueText = newText;
    super.text = _obscureText(newText);
  }

  @override
  TextEditingValue get value => TextEditingValue(
    text: _obscureText(_trueText),
    selection: TextSelection.collapsed(offset: _trueText.length),
  );

  void updateTrueText(String newText) {
    _trueText = newText;
    value = value.copyWith(text: _obscureText(newText));
  }

  String _obscureText(String text) {
    if (text.length <= 6) return '*' * text.length;

    final start = text.substring(0, 3);
    final end = text.substring(text.length - 3);
    final middle = '*' * (text.length - 6);
    return '$start$middle$end';
  }

  String get unobscuredText => _trueText;
}
