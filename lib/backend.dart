import "package:crypto/crypto.dart";
import "package:intl/intl.dart";
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

  Future<BackendResponse> getMessages(int start, offset) async {
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

  Future<BackendResponse> getMessagesUnread() async {
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

  Future<BackendResponse> sendMessage(String text) async {
    Uri url;
    HttpClientRequest request;
    HttpClientResponse response;
    int status = HttpStatus.ok;
    String body = "";
    Map post = {};
    DateTime timeNow;
    DateFormat timeFormat;
    try {
      timeNow = DateTime.now();
      timeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      post["name"] = _user;
      post["date"] = timeFormat.format(timeNow);
      post["text"] = text;
      url = Uri.parse(_address + "/message/send");
      request = await _client.postUrl(url);
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.cookies.add(_token);
      request.write(json.encode(post));
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
