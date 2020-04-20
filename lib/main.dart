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
  bool _isComposing = false;
  AnimationController _animationButton;
  Animation _tweenButton;

  @override
  void initState() {
    _animationButton = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // "BuildContext" object is a handle to the location of a widget in your app's widget tree
    _tweenButton = ColorTween(begin: Colors.grey[400], end: Colors.blue[700])
        .animate(_animationButton);
    super.initState();
  }

  @override
  // it is good practice to dispose of your animation controllers to free up your resources when they are no longer needed
  // in the current app, the framework does not call the dispose() method since the app only has a single screen
  void dispose() {
    _animationButton.dispose();
    for (final ChatMessage message in _messages)
      message.animationControllerMessage.dispose();
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
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    // attach an animation controller to a ChatMessage instance
    ChatMessage message = ChatMessage(
      text: text,
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
          // Flexible tells the Row to automatically size the TextField to use the remaining space that isn't used by the button
          Flexible(
            child: TextField(
              // every callback needs a handle and so the function shall have the word "handle" in its name
              // to be notified about changes to the text as the user interacts with the field, pass an "onChanged" callback to the TextField constructor
              // "_isComposing" variable controls the behavior and the visual appearance of the Send button
              onChanged: _handleChanged,
              onSubmitted: _isComposing ? _handleSubmitted : null,
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: "Send message",
              ),
            ),
          ),
          Container(
              // units here are logical pixels that get translated into a specific number of physical pixels
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: AnimatedBuilder(
                animation: _animationButton,
                builder: (context, child) => IconButton(
                  // "_isComposing" variable controls the behavior and the visual appearance of the Send button
                  onPressed: () => _isComposing
                      ? _handleSubmitted(_textController.text)
                      : null,
                  color: _tweenButton.value,
                  icon: Icon(Icons.send),
                  tooltip: "Send message",
                ),
              ))
        ],
      ),
    );
  }
}

// we want to store chat messages in a Dart list, thus we define a corresponding chat message class right away
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationControllerMessage});

  final String text;
  final AnimationController animationControllerMessage;
  final String _name = "Arnd";

  @override
  Widget build(BuildContext context) {
    // SizeTransition provides an animation effect where the width or height of its child is multiplied by a given size factor value
    // CurvedAnimation object in conjunction with the SizeTransition produces an ease-out animation effect
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationControllerMessage,
        curve: Curves.elasticOut
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subtitle1),
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
