import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/app/pages/navigator.dart';
import 'package:flutter_login_jwt/data/helpers/http_overrides_helper.dart';
import 'package:flutter_login_jwt/domain/entities/routes.dart';

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
      initialRoute: Routes.home,
      onGenerateRoute: AppNavigator.onGenerateRoute,
    );
  }
}
