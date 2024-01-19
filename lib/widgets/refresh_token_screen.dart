import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/features/authentication.dart';
import 'package:flutter_login_jwt/widgets/main_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RefreshTokenScreen extends StatefulWidget {
  // Properties
  final void Function() onRefreshFailed;

  // Constructor
  const RefreshTokenScreen({
    super.key,
    required this.onRefreshFailed,
  });

  @override
  State<RefreshTokenScreen> createState() => _RefreshTokenScreenState();
}

class _RefreshTokenScreenState extends State<RefreshTokenScreen> {
  bool _isRefreshing = false;

  // Refresh Method
  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
    });

    final response = await refreshAccessToken();

    // Add some delay to simulate a slow network
    await Future.delayed(const Duration(seconds: 1));

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
      throw Exception('Cannot refresh token');
    }
  }

  void _handleRefresh() {
    _refresh().then((_) {
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
              onPressed: () {
                Navigator.pop(context);
                widget.onRefreshFailed();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Refresh Token'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text('Refreshing Token'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ));
  }
}
