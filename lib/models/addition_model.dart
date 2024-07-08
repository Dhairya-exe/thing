import 'package:flutter/material.dart';

class AdditionModel {
  late TextEditingController textController;

  void init() {
    textController = TextEditingController();
  }

  void dispose() {
    textController.dispose();
  }
}
