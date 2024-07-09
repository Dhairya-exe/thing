import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpellingWidget extends StatefulWidget {
  final List<String> wordList;

  const SpellingWidget({Key? key, required this.wordList}) : super(key: key);

  @override
  _SpellingWidgetState createState() => _SpellingWidgetState();
}

class _SpellingWidgetState extends State<SpellingWidget> {
  late String currentWord;
  TextEditingController answerController = TextEditingController();
  bool? isCorrect;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _pickRandomWord();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _pickRandomWord() {
    final random = Random();
    currentWord = widget.wordList[random.nextInt(widget.wordList.length)];
    setState(() {
      isCorrect = null;
    });
  }

  Future<void> _speakWord() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(currentWord);
  }

  void _checkAnswer() {
    String typedAnswer = answerController.text.trim().toLowerCase();
    if (typedAnswer == currentWord.toLowerCase()) {
      setState(() {
        isCorrect = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        _pickRandomWord();
        answerController.clear(); // Clear the text box
        isCorrect = null; // Reset correctness indicator
      });
    } else {
      setState(() {
        isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _speakWord,
              icon: Icon(Icons.volume_up),
              label: Text('Word'),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your answer',
                      errorText: isCorrect == false ? 'Incorrect.' : null,
                      helperText: isCorrect == true ? 'Correct!' : null,
                      errorStyle: TextStyle(color: Colors.red),
                      helperStyle: TextStyle(color: Colors.green),
                    ),
                    enabled: isCorrect == null,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
