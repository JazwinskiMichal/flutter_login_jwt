import 'package:flutter/material.dart';
import 'package:flutter_login_jwt/app/pages/refresh_token/refresh_token_view.dart';
import 'package:flutter_login_jwt/domain/entities/routes.dart';

class AppNavigator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const RefreshTokenPage());
      case Routes.refreshToken:
        return MaterialPageRoute(builder: (context) => const RefreshTokenPage());
    }
    return _generateErrorRoute();
  }

  static Route<dynamic> _generateErrorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('error'),
        ),
        body: const Center(
          child: Text('error'),
        ),
      );
    });
  }
}
