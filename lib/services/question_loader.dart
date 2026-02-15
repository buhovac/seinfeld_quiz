import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

class QuestionLoader {
  static const String _path = 'assets/questions/questions_v1.json';

  Future<QuestionBank> load() async {
    final raw = await rootBundle.loadString(_path);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return QuestionBank.fromJson(decoded);
  }
}
