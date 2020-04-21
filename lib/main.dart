import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
  accentColor: Colors.orange[400],
  accentColorBrightness: Brightness.light,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

void main() => runApp(Netchat());

class Netchat extends StatelessWidget {
  final title = "netchat";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? iOSTheme
          : androidTheme,
      initialRoute: "login",
      routes: {
        "login": (context) => ChatLogin(title: ""),
        "home": (context) => ChatScreen(title: ""),
        "settings": (context) => ChatSettings(title: "Settings"),
      },
    );
  }
}

class ChatLogin extends StatefulWidget {
  ChatLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  // create a global key that uniquely identifies the Form widget and allows validation of the form
  // GlobalKey is the recommended way to access a form, however if you have a more complex widget tree, you can also use "Form.of()"
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    // Form widget acts as a container for grouping and validating multiple form fields
    return Scaffold(
      body: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 64.0, vertical: 22.0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.horizontal(
                            left: const Radius.circular(32.0),
                            right: const Radius.circular(32.0),
                          ),
                        ),
                        prefixIcon: Icon(Icons.perm_identity),
                        labelText: "User",
                        fillColor: Colors.white70),
                    onSaved: (text) => null,
                    validator: (text) {
                      if (text.isEmpty)
                        return "Missing user";
                      else
                        return null;
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.horizontal(
                            left: const Radius.circular(32.0),
                            right: const Radius.circular(32.0),
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        fillColor: Colors.white70),
                    obscureText: true,
                    onSaved: (text) => null,
                    validator: (text) {
                      if (text.isEmpty)
                        return "Incorrect password";
                      else
                        return null;
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 42.0),
                child: SizedBox(
                  width: 128,
                  child: RaisedButton(
                    color: Colors.orange[200],
                    child: Text("Login".toUpperCase()),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.of(context).pushReplacementNamed("home");
                      } else {
                        setState(() => _autoValidate = true);
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

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
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Text("Go back!"),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.title}) : super(key: key);

  final String title;

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
    // "BuildContext" object is a handle to the location of a widget in your app"s widget tree
    _tweenButton =
        ColorTween(begin: Colors.grey[400], end: iOSTheme.accentColor)
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
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 40.0,
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
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
          // Flexible tells the Row to automatically size the TextField to use the remaining space that isn"t used by the button
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
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
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
                        color: _tweenButton.value,
                        icon: Icon(Icons.send),
                        tooltip: "Send message",
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
          parent: animationControllerMessage, curve: Curves.elasticOut),
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
