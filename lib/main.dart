import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/app/pages/refresh_token/refresh_token_view.dart';
import 'package:flutter_login_jwt/data/helpers/http_overrides_helper.dart';

void main() {
  HttpOverrides.global = HttpOverridesHelper();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RefreshTokenPage(),
    );
  }
}
