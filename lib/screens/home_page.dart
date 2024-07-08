import 'package:flutter/material.dart';
import 'package:math/screens/addition_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdditionWidget()),
            );
          },
          child: Text('Start Addition Quiz'),
        ),
      ),
    );
  }
}
