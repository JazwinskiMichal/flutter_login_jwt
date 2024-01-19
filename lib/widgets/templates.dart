import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/widgets/login_screen.dart';
import 'package:flutter_login_jwt/widgets/refresh_token_screen.dart';

class Templates extends StatefulWidget {
  const Templates({super.key});

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  Widget? activeScreen;

  @override
  void initState() {
    super.initState();
    activeScreen = RefreshTokenScreen(
      onRefreshFailed: onRefreshFailed,
    );
  }

  void onRefreshFailed() {
    setState(() {
      activeScreen = const LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.red,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: activeScreen,
        ),
      ),
    );
  }
}
