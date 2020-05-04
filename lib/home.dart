import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "dart:convert";
import "main.dart" show iOSTheme, androidTheme;
import "backend.dart";

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.backend, this.title}) : super(key: key);

  final String title;
  final Backend backend;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  AnimationController _animationButton;
  Animation _tweenButton;
  String _user;

  @override
  void initState() {
    _animationButton = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // "BuildContext" object is a handle to the location of a widget in your app"s widget tree
    _tweenButton = ColorTween(
            begin: Colors.grey[400],
            end: defaultTargetPlatform != TargetPlatform.android
                ? iOSTheme.accentColor
                : androidTheme.accentColor)
        .animate(_animationButton);
    _handleUser();
    _handleMessages();
    super.initState();
  }

  void _handleUser() {
    widget.backend.user().then((value) {
      Map<String, dynamic> map = jsonDecode(value.body);
      _user = map["user"];
      debugPrint("Welcome back, $_user!");
    });
  }

  void _handleMessages() {
    widget.backend.messages(0, 10).then((value) {
      List<dynamic> list = jsonDecode(value.body);
      for (Map<String, dynamic> map in list) {
        ChatMessage message = ChatMessage(
          name: map["name"].toString().capitalize(),
          text: map["text"],
          user: map["name"].toString().equal(_user),
          animationControllerMessage: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          ),
        );
        setState(() {
          _messages.insert(0, message);
        });
        message.animationControllerMessage.forward();
      }
    });
  }

  @override
  // it is good practice to dispose of your animation controllers to free up your resources when they are no longer needed
  // in the current app, the framework does not call the dispose() method since the app only has a single screen
  void dispose() {
    _animationButton.dispose();
    _textController.dispose();
    for (final ChatMessage message in _messages)
      message.animationControllerMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "settings"),
              child: Tooltip(
                message: "Settings",
                child: Icon(
                  Icons.cloud_queue,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
        // "elevation" property defines the z-coordinates of the AppBar
        // z-coordinate value of 0.0 has no shadow (iOS) and a value of 4.0 has a defined shadow (Android)
        elevation:
            Theme.of(context).platform != TargetPlatform.android ? 0.0 : 40.0,
      ),
      body: Container(
        decoration: Theme.of(context).platform != TargetPlatform.android
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[400]),
                ),
              )
            : null,
        child: Column(
          children: <Widget>[
            // Flexible as a parent of ListView lets the list of received messages expand to fill the Column height while TextField remains a fixed size
            Flexible(
              // construct a list where its children widgets are built on demand
              // "ListView.builder()" constructor creates items as they are scrolled onto the screen
              // the in-place callback function returns a widget at each call
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
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
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    // attach an animation controller to a ChatMessage instance
    ChatMessage message = ChatMessage(
      name: _user.capitalize(),
      text: text,
      user: true,
      animationControllerMessage: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );
    setState(() {
      _textController.clear();
      _animationButton.reverse();
      _messages.insert(0, message);
      _isComposing = false;
    });
    // specify that the animation should play forward whenever a message is added to the chat list
    message.animationControllerMessage.forward();
  }

  void _handleChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
      if (_isComposing)
        _animationButton.forward();
      else
        _animationButton.reverse();
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          // Flexible tells the Row to automatically size the TextField to use the remaining space that isn"t used by the button
          Flexible(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: "Send message",
              ),
              autofocus: true,
              controller: _textController,
              // every callback needs a handle and so the function shall have the word "handle" in its name
              // to be notified about changes to the text as the user interacts with the field, pass an "onChanged" callback to the TextField constructor
              // "_isComposing" variable controls the behavior and the visual appearance of the Send button
              onChanged: _handleChanged,
              onSubmitted: _isComposing ? _handleSubmitted : null,
            ),
          ),
          Container(
              // units here are logical pixels that get translated into a specific number of physical pixels
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Theme.of(context).platform != TargetPlatform.android
                  ? AnimatedBuilder(
                      animation: _animationButton,
                      builder: (context, child) => CupertinoButton(
                        child: Text(
                          "Send",
                          style: TextStyle(color: _tweenButton.value),
                        ),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      ),
                    )
                  : AnimatedBuilder(
                      animation: _animationButton,
                      builder: (context, child) => IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: _tweenButton.value,
                        icon: Icon(Icons.send),
                        onPressed: () => _isComposing
                            ? _handleSubmitted(_textController.text)
                            : null,
                      ),
                    ))
        ],
      ),
    );
  }
}

// we want to store chat messages in a Dart list, thus we define a corresponding chat message class right away
class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.name, this.text, this.user, this.animationControllerMessage});

  final String text;
  final String name;
  final bool user;
  final AnimationController animationControllerMessage;

  @override
  Widget build(BuildContext context) {
    // SizeTransition provides an animation effect where the width or height of its child is multiplied by a given size factor value
    // CurvedAnimation object in conjunction with the SizeTransition produces an ease-out animation effect
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationControllerMessage, curve: Curves.elasticOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: user ? Theme.of(context).primaryColorLight : Colors.black12,
                foregroundColor: user ? Theme.of(context).primaryColorDark : Colors.black54,
                child: Text(name[0].toUpperCase()),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
  bool equal(String str) {
    return this.toLowerCase() == str.toLowerCase();
  }
}
