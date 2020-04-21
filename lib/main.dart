import "package:flutter/material.dart";
import "login.dart";
import "home.dart";
import "settings.dart";

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
  accentColor: Colors.orange[400],
  accentColorBrightness: Brightness.light,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.purple,
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
        "home": (context) => ChatScreen(title: "Netchat"),
        "settings": (context) => ChatSettings(title: "Settings"),
      },
    );
  }
}
