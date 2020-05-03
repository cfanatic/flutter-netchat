import "package:crypto/crypto.dart";
import "dart:io";
import "dart:convert";
import "parameter.dart";

class Backend {
  Backend(this._user, this._password) {
    this._hash = sha256.convert(utf8.encode(_password + Parameter.secretKey));
    this._address = "https://${Parameter.address}:${Parameter.port}";
    this._client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == Parameter.address;
      };
  }

  HttpClient _client;
  String _user;
  String _password;
  String _address;
  Digest _hash;
  // Map<String, String> _header = {};

  Future<int> login() async {
    final String addr = _address + "/login/$_user/$_hash";
    final Uri url = Uri.parse(addr);
    int status = HttpStatus.ok;
    try {
      var request = await _client.getUrl(url);
      var response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        response.transform(utf8.decoder).listen((data) {
          var contents = StringBuffer();
          contents.writeln(data);
          print(contents.toString());
        });
        status = response.statusCode;
      }
      print(response.headers.value("set-cookie"));
    } on SocketException catch (error) {
      status = HttpStatus.gatewayTimeout;
      print(error.toString());
    } catch (error) {
      status = HttpStatus.internalServerError;
      print(error.toString());
    }
    return status;
  }
}
