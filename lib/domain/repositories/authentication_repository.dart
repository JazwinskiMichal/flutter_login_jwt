import 'package:http/http.dart' as http;

abstract class AuthenticationRepository {
  Future<http.Response> requestAccessToken(String email, String password);
  Future<http.Response> refreshAccessToken();
  Future<void> saveAccessToken(String token);
}
