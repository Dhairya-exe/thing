import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Go to Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addition');
              },
              child: Text('Start Addition Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/multiplication');
              },
              child: Text('Start Multiplication Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/spelling');
              },
              child: Text('Start Spelling Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
