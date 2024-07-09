import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpellingWidget extends StatefulWidget {
  final List<String> wordList;

  const SpellingWidget({
    Key? key,
    required this.wordList,
  }) : super(key: key);

  @override
  _SpellingWidgetState createState() => _SpellingWidgetState();
}

class _SpellingWidgetState extends State<SpellingWidget> {
  late FlutterTts flutterTts;
  late stt.SpeechToText speech;

  String currentWord = '';
  String userInput = '';
  bool isCorrect = false;
  int correctCount = 0;
  int currentIndex = 0;

  void initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage('en-US');
  }

  void initSpeech() {
    speech = stt.SpeechToText();
    speech.initialize();
    speech.listen(
      onResult: (result) {
        setState(() {
          userInput = result.recognizedWords.trim();
          checkAnswer();
        });
      },
    );
  }

  void speak(String text) async {
    await flutterTts.speak(text);
  }

  void nextWord() {
    currentIndex++;
    if (currentIndex < widget.wordList.length) {
      setState(() {
        currentWord = widget.wordList[currentIndex];
        isCorrect = false;
        userInput = '';
      });
      speak(currentWord);
    } else {
      // Navigate to results page when all words are spelled
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpellingResultsPage(
            correctAnswers: correctCount,
            totalQuestions: widget.wordList.length,
          ),
        ),
      );
    }
  }

  void checkAnswer() {
    if (userInput.toLowerCase() == currentWord.toLowerCase()) {
      setState(() {
        isCorrect = true;
        correctCount++;
      });
      // Delay for 3 seconds before moving to the next word
      Future.delayed(Duration(seconds: 3), () {
        nextWord();
      });
    } else {
      setState(() {
        isCorrect = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.wordList.isNotEmpty) {
      currentWord = widget.wordList[currentIndex];
      initTts();
      speak(currentWord);
      initSpeech();
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Spell this word:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              currentWord,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                userInput = value;
              },
              decoration: InputDecoration(
                hintText: 'Type your answer',
              ),
              onEditingComplete: () {
                checkAnswer();
              },
            ),
            SizedBox(height: 20),
            if (isCorrect)
              Text(
                'Correct!',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            if (!isCorrect && userInput.isNotEmpty)
              Text(
                'Incorrect, try again.',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}

class SpellingResultsPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const SpellingResultsPage({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Quiz Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Correct Answers: $correctAnswers / $totalQuestions',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Percentage: ${percentage.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous screen
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
