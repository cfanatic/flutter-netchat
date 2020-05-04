import "package:crypto/crypto.dart";
import "dart:io";
import "dart:convert";
import "parameter.dart";

class BackendResponse {
  const BackendResponse(this.status, this.body);
  final status;
  final body;
}

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
  Cookie _token;

  Future<BackendResponse> login() async {
    Uri url;
    HttpClientRequest request;
    HttpClientResponse response;
    int status = HttpStatus.ok;
    String body = "";
    try {
      url = Uri.parse(_address + "/login/$_user/$_hash");
      request = await _client.getUrl(url);
      response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        status = response.statusCode;
      } else {
        response.cookies.forEach((element) {
          if (element.name == "token") _token = element;
        });
      }
      await for (var tmp in response.transform(utf8.decoder)) {
        body = tmp;
      }
    } on SocketException catch (_) {
      status = HttpStatus.gatewayTimeout;
    } catch (error) {
      status = HttpStatus.internalServerError;
    }
    return BackendResponse(status, body);
  }

  Future<BackendResponse> user() async {
    Uri url;
    HttpClientRequest request;
    HttpClientResponse response;
    int status = HttpStatus.ok;
    String body = "";
    try {
      url = Uri.parse(_address + "/user");
      request = await _client.getUrl(url);
      request.cookies.add(_token);
      response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        status = response.statusCode;
      }
      await for (var tmp in response.transform(utf8.decoder)) {
        body = tmp;
      }
    } on SocketException catch (_) {
      status = HttpStatus.gatewayTimeout;
    } catch (error) {
      status = HttpStatus.internalServerError;
    }
    return BackendResponse(status, body);
  }

  Future<BackendResponse> messages(int start, offset) async {
    Uri url;
    HttpClientRequest request;
    HttpClientResponse response;
    int status = HttpStatus.ok;
    String body = "";
    try {
      url = Uri.parse(_address + "/messages/$start/$offset");
      request = await _client.getUrl(url);
      request.cookies.add(_token);
      response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        status = response.statusCode;
      }
      await for (var tmp in response.transform(utf8.decoder)) {
        body = tmp;
      }
    } on SocketException catch (_) {
      status = HttpStatus.gatewayTimeout;
    } catch (error) {
      status = HttpStatus.internalServerError;
    }
    return BackendResponse(status, body);
  }

  Future<BackendResponse> messagesUnread() async {
    Uri url;
    HttpClientRequest request;
    HttpClientResponse response;
    int status = HttpStatus.ok;
    String body = "";
    try {
      url = Uri.parse(_address + "/messages/unread");
      request = await _client.getUrl(url);
      request.cookies.add(_token);
      response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        status = response.statusCode;
      }
      await for (var tmp in response.transform(utf8.decoder)) {
        body = tmp;
      }
    } on SocketException catch (_) {
      status = HttpStatus.gatewayTimeout;
    } catch (error) {
      status = HttpStatus.internalServerError;
    }
    return BackendResponse(status, body);
  }
}
