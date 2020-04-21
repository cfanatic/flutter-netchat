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
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Form widget acts as a container for grouping and validating multiple form fields
      body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64.0,
                  vertical: 22.0,
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  // TextFormField widget renders a material design text field and can display validation errors when they occur
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.orange[200]),
                  // TextFormField widget renders a material design text field and can display validation errors when they occur
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
              Container(
                padding: EdgeInsets.only(top: 42.0),
                child: SizedBox(
                  width: 128,
                  // when the user attempts to submit the form, check if the form is valid
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
