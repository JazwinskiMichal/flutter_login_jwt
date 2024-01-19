import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/login/login_presenter.dart';

import 'package:http/http.dart' as http;

class LoginController extends Controller {
  // Private fieds
  bool _isLoggingIn = false;
  bool _isAuthenticated = false;

  // Properties
  final LoginPresenter loginPresenter;

  // Getters
  bool get isLoggingIn => _isLoggingIn;
  bool get isAuthenticated => _isAuthenticated;

  // Inject required repositories/controllers into constructor
  LoginController(authenticationRepo)
      : loginPresenter = LoginPresenter(authenticationRepo),
        super();

  @override
  void initListeners() {
    loginPresenter.onLoginSuccess = (http.Response response) {
      _isAuthenticated = true;
      _isLoggingIn = false;

      refreshUI();
    };

    loginPresenter.onLoginFailed = (e) {
      _isAuthenticated = false;
      _isLoggingIn = false;

      ScaffoldMessenger.of(getContext()).showSnackBar(
        const SnackBar(
          content: Text('Failed to login'),
        ),
      );

      refreshUI();
    };
  }

  void login(String email, String password) {
    _isLoggingIn = true;
    _isAuthenticated = false;
    loginPresenter.login(email, password);
    refreshUI();
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDisposed() {
    loginPresenter.dispose();
    super.onDisposed();
  }
}
