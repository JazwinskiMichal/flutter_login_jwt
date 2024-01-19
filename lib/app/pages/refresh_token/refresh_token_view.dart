import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart' as clean_architecture;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/refresh_token/refresh_token_controller.dart';

import '../../../data/repositories/data_authentication_repository.dart';

class RefreshTokenPage extends clean_architecture.View {
  const RefreshTokenPage({super.key});

  @override
  RefreshTokenPageState createState() => RefreshTokenPageState();
}

class RefreshTokenPageState extends clean_architecture.ViewState<RefreshTokenPage, RefreshTokenController> {
  RefreshTokenPageState() : super(RefreshTokenController(DataAuthenticationRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Refresh Token'),
      ),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Refreshing Token'),
                const SizedBox(height: 20),
                ControlledWidgetBuilder<RefreshTokenController>(
                  builder: (context, controller) {
                    return controller.isRefreshing
                        ? const CircularProgressIndicator()
                        : controller.isRefreshed
                            ? const Text('Token refreshed')
                            : Column(
                                children: [
                                  const Text('Cannot refresh token'),
                                  TextButton(
                                    onPressed: () {
                                      controller.refreshAccessToken();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
