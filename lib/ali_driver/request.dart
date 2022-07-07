import 'dart:convert';
import 'dart:io';

class Request {
  static const _userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36';
  static const _baseHost = 'https://api.aliyundrive.com';
  static const _referer = 'https://www.aliyundrive.com/';

  final client = HttpClient();
  final String bearerToken;

  Request({required this.bearerToken});


  get(String url, {Map<String, String> ?params}) async {
    if (!url.contains('://')){
      url = _baseHost + url;
    }

    var uri = Uri.parse(url).replace(queryParameters: params);

    var request = await client.getUrl(uri);

    _initializationRequest(request);

    var response = await request.close();

  }

  Future<Response> post(String url, {Map<String, dynamic> ?data}) async {
    if (!url.contains('://')){
      url = _baseHost + url;
    }

    var uri = Uri.parse(url);

    var request = await client.postUrl(uri);

    _initializationRequest(request);

    if(data != null){
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode(data));
    }

    var response = await request.close();

    var body = await response.transform(utf8.decoder).join();

    var bodyJson = jsonDecode(body);

    if (response.statusCode < 200){
      throw HttpException(response: response, status: response.statusCode, body: bodyJson);
    }

    return Response(response: response, status: response.statusCode, body: bodyJson);
  }


  _initializationRequest(HttpClientRequest request){
    request.headers.set('referer', _referer);
    request.headers.set('origin', _referer);
    request.headers.set('user-agent', _userAgent);
    request.headers.set('Authorization', 'Bearer ' + bearerToken);
  }
}

class Response {
  final HttpClientResponse response;
  final int status;
  final Map<String, dynamic> body;

  Response({required this.response, required this.status, required this.body});
}

class HttpException implements Exception{
  final HttpClientResponse response;
  final int status;
  final Map<String, dynamic> body;

  HttpException({required this.response, required this.status, required this.body});
}