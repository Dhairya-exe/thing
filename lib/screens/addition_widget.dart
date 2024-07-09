import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdditionWidget extends StatefulWidget {
  final int minNumber;
  final int maxNumber;

  const AdditionWidget({
    Key? key,
    required this.minNumber,
    required this.maxNumber,
  }) : super(key: key);

  @override
  _AdditionWidgetState createState() => _AdditionWidgetState();
}

class _AdditionWidgetState extends State<AdditionWidget> {
  late int num1;
  late int num2;
  late int answer;
  late TextEditingController controller;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
    controller = TextEditingController();
  }

  void _generateNumbers() {
    final random = Random();
    num1 = random.nextInt(widget.maxNumber - widget.minNumber + 1) + widget.minNumber;
    num2 = random.nextInt(widget.maxNumber - widget.minNumber + 1) + widget.minNumber;
    answer = num1 + num2;
    setState(() {
      isCorrect = false;
    });
  }

  void _checkAnswer(String typedAnswer) {
    if (typedAnswer.isNotEmpty) {
      int? userAnswer = int.tryParse(typedAnswer);
      if (userAnswer != null && userAnswer == answer) {
        setState(() {
          isCorrect = true;
        });
        Future.delayed(Duration(seconds: 2), () {
          _generateNumbers();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addition Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '$num1 + $num2 = ?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _checkAnswer(value),
            ),
            SizedBox(height: 20),
            if (isCorrect)
              Text(
                'Correct!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
