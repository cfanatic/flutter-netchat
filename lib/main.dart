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

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  // it is good practice to dispose of your animation controllers to free up your resources when they are no longer needed
  // in the current app, the framework does not call the dispose() method since the app only has a single screen
  void dispose() {
    for (final ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

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
            // construct a list where its children widgets are built on demand
            // "ListView.builder()" constructor creates items as they are scrolled onto the screen
            // the in-place callback function returns a widget at each call
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (BuildContext context, int index) =>
                  _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
              // use decoration to create a BoxDecoration object that defines the background color
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
    // attach an animation controller to a ChatMessage instance
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    // specify that the animation should play forward whenever a message is added to the chat list
    message.animationController.forward();
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
                // every callback needs a handle and so the function shall have the word "handle" in its name
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
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;
  final String _name = "Arnd";

  @override
  Widget build(BuildContext context) {
    // SizeTransition provides an animation effect where the width or height of its child is multiplied by a given size factor value
    // CurvedAnimation object in conjunction with the SizeTransition produces an ease-out animation effect
    /*
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut
      ),
      axisAlignment: 0.0,
    */
    return FadeTransition(
      opacity: animationController,
      child: Container(
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
      ),
    );
  }
}
