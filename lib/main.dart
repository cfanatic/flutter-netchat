import 'package:flutter/material.dart';

void main() => runApp(Netchat());

class Netchat extends StatelessWidget {
  final title = "Netchat";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(),
      ),
    );
  }
}