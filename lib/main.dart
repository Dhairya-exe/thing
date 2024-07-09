import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/addition_widget.dart';
import 'screens/multiplication_widget.dart';
import 'screens/spelling_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math & Spelling App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/addition': (context) => MathQuizWrapper(
              quizType: MathQuizType.addition,
            ),
        '/multiplication': (context) => MathQuizWrapper(
              quizType: MathQuizType.multiplication,
            ),
        '/spelling': (context) => SpellingWrapper(),
      },
    );
  }
}

enum MathQuizType {
  addition,
  multiplication,
}

class MathQuizWrapper extends StatefulWidget {
  final MathQuizType quizType;

  const MathQuizWrapper({Key? key, required this.quizType}) : super(key: key);

  @override
  _MathQuizWrapperState createState() => _MathQuizWrapperState();
}

class _MathQuizWrapperState extends State<MathQuizWrapper> {
  late int minNumber;
  late int maxNumber;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      minNumber = prefs.getInt('minNumber') ?? 1;
      maxNumber = prefs.getInt('maxNumber') ?? 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.quizType) {
      case MathQuizType.addition:
        return AdditionWidget(
          minNumber: minNumber,
          maxNumber: maxNumber,
        );
      case MathQuizType.multiplication:
        return MultiplicationWidget(
          minNumber: minNumber,
          maxNumber: maxNumber,
        );
    }
  }
}

class SpellingWrapper extends StatefulWidget {
  @override
  _SpellingWrapperState createState() => _SpellingWrapperState();
}

class _SpellingWrapperState extends State<SpellingWrapper> {
  List<String> wordList = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wordList = prefs.getStringList('wordList') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpellingWidget(wordList: wordList);
  }
}
