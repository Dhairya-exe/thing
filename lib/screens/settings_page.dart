import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  List<String> wordList = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _minController = TextEditingController(text: prefs.getInt('minNumber')?.toString() ?? '1');
      _maxController = TextEditingController(text: prefs.getInt('maxNumber')?.toString() ?? '10');
      wordList = prefs.getStringList('wordList') ?? [];
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('minNumber', int.parse(_minController.text));
    prefs.setInt('maxNumber', int.parse(_maxController.text));
    prefs.setStringList('wordList', wordList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Number Range:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Text('Minimum:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text('Maximum:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Word List for Spelling Mode:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(wordList.length, (index) {
                  return Row(
                    children: <Widget>[
                      Text('${index + 1}.'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: wordList[index],
                          onChanged: (value) {
                            setState(() {
                              wordList[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            wordList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  wordList.add(''); // Add an empty string for a new word
                  setState(() {});
                },
                child: Text('Add Word'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Settings saved')),
                  );
                },
                child: Text('Save Settings'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to previous screen
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }
}
