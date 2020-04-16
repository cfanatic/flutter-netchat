import 'package:flutter/material.dart';

void main() => runApp(Netchat());

class Netchat extends StatelessWidget {
  final title = "Netchat";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: ChatScreen(title: title),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String title;

  ChatScreen({Key key, this.title}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          // Flexible as a parent of ListView lets the list of received messages expand to fill the Column height while TextField remains a fixed size
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (BuildContext context, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
              // use decoration to create a new BoxDecoration object that defines the background color
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer()),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      // "BuildContext" object is a handle to the location of a widget in your app's widget tree
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // Flexible tells the Row to automatically size the TextField to use the remaining space that isn't used by the button
            Flexible(
              child: TextField(
                // every callback needs a handle and so the function name shall have "handle" in its word
                onSubmitted: _handleSubmitted,
                controller: _textController,
                decoration: InputDecoration.collapsed(
                  hintText: "Send message",
                ),
              ),
            ),
            Container(
                // units here are logical pixels that get translated into a specific number of physical pixels
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () => _handleSubmitted(_textController.text),
                  icon: Icon(Icons.send),
                  tooltip: "Send message",
                ))
          ],
        ),
      ),
    );
  }
}

// we want to store chat messages in a Dart list, thus we define a corresponding chat message class right away
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});

  final String _name = "Arnd";
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_name, style: Theme.of(context).textTheme.subtitle1),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
