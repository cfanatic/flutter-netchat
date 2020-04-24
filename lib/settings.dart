import "package:flutter/material.dart";

class ChatSettings extends StatefulWidget {
  ChatSettings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatSettingsState createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.keyboard_backspace,
              size: 22.0,
            ),
          ),
        ),
        elevation:
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 40.0,
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[400]),
                ),
              )
            : null,
        child: Center(
          child: RaisedButton(
            onPressed: () {},
            child: Text("Go back!"),
          ),
        ),
      ),
    );
  }
}
