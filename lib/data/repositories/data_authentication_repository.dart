import 'dart:convert';

import 'package:flutter_login_jwt/data/api_constants.dart';
import 'package:flutter_login_jwt/domain/repositories/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class DataAuthenticationRepository extends AuthenticationRepository {
  @override
  Future<http.Response> requestAccessToken(String email, String password) async {
    var parameters = {
      'username': email,
      'password': password,
      'Scope': scope,
    };

    // Get the HTTP client
    var client = http.Client();

    // Request the token
    var response = await client.post(
      Uri.parse(baseUrl),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'icpen_credentials',
        ...parameters,
      },
    );

    return response;
  }

  @override
  Future<http.Response> refreshAccessToken() async {
    String? refreshToken = await storage.read(key: refreshTokenKey);

    // Get the HTTP client
    var client = http.Client();

    // Request the new token
    var response = await client.post(
      Uri.parse(baseUrl),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken ?? '',
      },
    );

    return response;
  }

  @override
  Future<void> saveAccessToken(String body) async {
    final token = jsonDecode(body)[tokenKey];
    final refreshToken = jsonDecode(body)[refreshTokenKey];

    // Save the token and refresh to the secure storage
    await storage.write(key: storageTokenKey, value: token);
    await storage.write(key: storageRefreshTokenKey, value: refreshToken);
  }
}
