import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/navigator.dart';
import 'package:flutter_login_jwt/app/pages/refresh_token/refresh_token_presenter.dart';
import 'package:http/http.dart' as http;

class RefreshTokenController extends Controller {
  // Private fieds
  bool _isRefreshing = false;
  bool _isRefreshed = false;

  // Properties
  final RefreshTokenPresenter refreshTokenPresenter;

  // Getters
  bool get isRefreshing => _isRefreshing;
  bool get isRefreshed => _isRefreshed;

  // Inject required repositories/controllers into constructor
  RefreshTokenController(authenticationRepo)
      : refreshTokenPresenter = RefreshTokenPresenter(authenticationRepo),
        super();

  void refreshAccessToken() {
    _isRefreshing = true;
    _isRefreshed = false;
    refreshTokenPresenter.refreshAccessToken();
    refreshUI();
  }

  @override
  void initListeners() {
    refreshAccessToken();

    refreshTokenPresenter.onRefreshSuccess = (http.Response response) {
      _isRefreshed = true;
      _isRefreshing = false;

      refreshUI();

      // Navigate to the next page
      AppNavigator.navigateToTemplates(getContext());
    };

    refreshTokenPresenter.onRefreshFailed = (e) {
      _isRefreshed = false;
      _isRefreshing = false;

      ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(
          content: Text('Failed to refresh token'),
        ),
      );

      refreshUI();
    };
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    refreshTokenPresenter.dispose();
    super.onDisposed();
  }
}
