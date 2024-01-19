import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Request an access token from the server
Future<http.Response> requestAccessToken(String email, String password) async {
  var clientId = 'icpendesktopapp';
  var grantType = 'icpen_credentials';
  var clientSecret = '';
  var parameters = {
    'username': email,
    'password': password,
    'Scope':
        'desktop_bff_api devices_signalrhub integration_amms_api offline_access openid profile',
  };

  // Get the HTTP client
  var client = http.Client();

  // Request the token
  var response = await client.post(
    Uri.parse('https://ip3-test.serwer.icpen.pl/auth/connect/token'),
    body: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': grantType,
      ...parameters,
    },
  );

  return response;
}

// Refresh the access token
Future<http.Response> refreshAccessToken() async {
  var clientId = 'icpendesktopapp';
  var grantType = 'refresh_token';
  var clientSecret = '';
  String? refreshToken = await storage.read(key: 'refresh_token');

  // Get the HTTP client
  var client = http.Client();

  // Request the new token
  var response = await client.post(
    Uri.parse('https://ip3-test.serwer.icpen.pl/auth/connect/token'),
    body: {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': grantType,
      'refresh_token': refreshToken ?? '',
    },
  );

  return response;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
