import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/features/authentication.dart';
import 'package:flutter_login_jwt/widgets/main_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Login Method
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Make a POST request to your backend API to authenticate the user
    final response = await requestAccessToken(email, password);

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

  void _handleLogin() {
    _login().then((_) {
      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
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
      ),
    );
  }
}
