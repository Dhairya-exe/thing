import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AdditionWidget extends StatefulWidget {
  @override
  _AdditionWidgetState createState() => _AdditionWidgetState();
}

class _AdditionWidgetState extends State<AdditionWidget> {
  int number1 = 0;
  int number2 = 0;
  int userInput = 0;
  bool isCorrect = false;

  void generateNumbers() {
    number1 = getRandomNumber();
    number2 = getRandomNumber();
    setState(() {});
  }

  int getRandomNumber() {
    return Random().nextInt(100); // Generate random numbers from 0 to 99
  }

  void checkAnswer() {
    if (userInput == (number1 + number2)) {
      setState(() {
        isCorrect = true;
      });

      // Delay for 3 seconds before generating a new question
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isCorrect = false;
          userInput = 0;
          generateNumbers();
        });
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
    generateNumbers();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Addition Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What is $number1 + $number2?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                userInput = int.tryParse(value) ?? 0;
              },
              decoration: InputDecoration(
                hintText: 'Enter your answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkAnswer();
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (isCorrect)
              Text(
                'Correct!',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            if (isCorrect)
              SizedBox(
                height: 20,
              ),
            if (!isCorrect && userInput != 0)
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
