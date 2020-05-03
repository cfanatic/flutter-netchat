import "package:flutter/material.dart";
import "dart:io";
import "backend.dart";
import "home.dart";

class ChatLogin extends StatefulWidget {
  ChatLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> with TickerProviderStateMixin {
  // create a global key that uniquely identifies the Form widget and allows validation of the form
  // GlobalKey is the recommended way to access a form, however if you have a more complex widget tree, you can also use "Form.of()"
  // FormState class contains the "validate()" method:
  // when the "validate()" method is called, it runs the "validator()" function for each text field in the form
  final _formKey = GlobalKey<FormState>();
  final _textUser = TextEditingController();
  final _textPassword = TextEditingController();
  Backend _backend;
  bool _autoValidate = false;
  AnimationController _animationController;
  Animation<double> _animationFadeInOut;
  String _errorLoginText = "";

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                _animationController.reverse();
              }
            },
          );
    _animationFadeInOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ))
          ..addListener(
            () {
              setState(() {});
            },
          );
  }

  @override
  void dispose() {
    _textUser.dispose();
    _textPassword.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Form widget acts as a container for grouping and validating multiple form fields
      body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              Spacer(flex: 3),
              Container(
                child: Text("Welcome to Netchat.",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Spacer(flex: 2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  // TextFormField widget renders a material design text field and can display validation errors when they occur
                  child: SizedBox(
                    height: 70,
                    child: TextFormField(
                      controller: _textUser,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(16.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                        ),
                        labelText: "User",
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (text) => null,
                      // validate the input by providing a validator() function to the TextFormField
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Missing user";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  // TextFormField widget renders a material design text field and can display validation errors when they occur
                  child: SizedBox(
                    height: 70,
                    child: TextFormField(
                      controller: _textPassword,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(16.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      onSaved: (text) => null,
                      // validate the input by providing a validator() function to the TextFormField
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Incorrect password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
              Container(
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textTheme: ButtonTextTheme.primary,
                  color: Colors.orange[200],
                  child: Text("Sign in".toUpperCase()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _handleLogin(_textUser.text, _textPassword.text)
                        ..then((response) {
                          if (response.status == HttpStatus.ok) {
                            _formKey.currentState.save();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                settings: const RouteSettings(name: "home"),
                                builder: (context) => ChatScreen(
                                  title: "Netchat",
                                  backend: _backend,
                                ),
                              ),
                            );
                          } else {
                            switch (response.status) {
                              case HttpStatus.unauthorized:
                                _errorLoginText = "User Unauthorized";
                                break;
                              case HttpStatus.internalServerError:
                                _errorLoginText = "Server Error";
                                break;
                              case HttpStatus.badRequest:
                                _errorLoginText = "Bad Request";
                                break;
                              case HttpStatus.gatewayTimeout:
                                _errorLoginText = "Server Timeout";
                                break;
                              default:
                                _errorLoginText = "";
                                break;
                            }
                            _animationController.forward();
                          }
                        });
                    } else {
                      setState(() => _autoValidate = true);
                    }
                  },
                ),
              ),
              Spacer(flex: 2),
              ErrorMessage(
                  animationFadeInOut: _animationFadeInOut,
                  text: _errorLoginText),
            ],
          )),
    );
  }

  Future<BackendResponse> _handleLogin(String user, password) async {
    _backend = Backend(user, password);
    return _backend.login();
  }
}

class ErrorMessage extends StatelessWidget {
  ErrorMessage({Key key, @required this.animationFadeInOut, this.text: ""})
      : super(key: key);

  final String text;
  final Animation<double> animationFadeInOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 64,
        child: FadeTransition(
          opacity: animationFadeInOut,
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.red[800]),
          ),
        ),
      ),
    );
  }
}
