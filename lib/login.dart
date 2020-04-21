import "package:flutter/material.dart";

class ChatLogin extends StatefulWidget {
  ChatLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  // create a global key that uniquely identifies the Form widget and allows validation of the form
  // GlobalKey is the recommended way to access a form, however if you have a more complex widget tree, you can also use "Form.of()"
  // FormState class contains the "validate()"" method:
  // when the "validate()" method is called, it runs the "validator()" function for each text field in the form
  final _formKey = GlobalKey<FormState>();
  final _textUser = TextEditingController();
  final _textPassword = TextEditingController();
  bool _autoValidate = false;

  @override
  void dispose() {
    _textUser.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Form widget acts as a container for grouping and validating multiple form fields
      body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Colors.grey[400],
                width: 1.0,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 196.0,
              horizontal: 64.0,
            ),
            child: Column(
              children: <Widget>[
                Spacer(flex: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Colors.orange[200]),
                    // TextFormField widget renders a material design text field and can display validation errors when they occur
                    child: TextFormField(
                      controller: _textUser,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
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
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (text) => null,
                      // validate the input by providing a validator() function to the TextFormField
                      validator: (text) {
                        if (text.isEmpty)
                          return "Missing user";
                        else
                          return null;
                      },
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Colors.orange[200]),
                    // TextFormField widget renders a material design text field and can display validation errors when they occur
                    child: TextFormField(
                      controller: _textPassword,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(32.0),
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      onSaved: (text) => null,
                      // validate the input by providing a validator() function to the TextFormField
                      validator: (text) {
                        if (text.isEmpty)
                          return "Incorrect password";
                        else
                          return null;
                      },
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Container(
                  child: RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                Spacer(flex: 2),
              ],
            ),
          )),
    );
  }
}
