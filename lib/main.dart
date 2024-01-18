import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login with Auth JWT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isRefreshing = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Make a POST request to your backend API to authenticate the user
    final response = await _requestAccessToken(email, password);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Successful login

      // Extract the token from the response body
      final token = jsonDecode(response.body)['access_token'];
      final refreshToken = jsonDecode(response.body)['refresh_token'];

      // Decode the token to get the user information
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Save the token and refresh to the secure storage
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'refresh_token', value: refreshToken);
      return;
    } else {
      // Failed login
      throw Exception('Invalid email or password');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
    });

    final response = await _refreshAccessToken();

    setState(() {
      _isRefreshing = false;
    });

    if (response.statusCode == 200) {
      // Successful login

      // Extract the token from the response body
      final token = jsonDecode(response.body)['access_token'];
      final refreshToken = jsonDecode(response.body)['refresh_token'];

      // Decode the token to get the user information
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Save the token and refresh to the secure storage
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'refresh_token', value: refreshToken);
      return;
    } else {
      // Failed login
      throw Exception('Invalid email or password');
    }
  }

  void _handleLogin() {
    _login().then((_) {
      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _handleRefresh() {
    _refresh().then((_) {
      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _isRefreshing ? null : _handleRefresh,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 5),
                  child: _isRefreshing
                      ? const CircularProgressIndicator()
                      : const Text('Refresh Token'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, elevation: 5),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Request an access token from the server
Future<http.Response> _requestAccessToken(String email, String password) async {
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
Future<http.Response> _refreshAccessToken() async {
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
