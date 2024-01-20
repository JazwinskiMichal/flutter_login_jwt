import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart' as clean_architecture;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/login/login_controller.dart';
import 'package:flutter_login_jwt/data/repositories/data_authentication_repository.dart';

class LoginPage extends clean_architecture.View {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends clean_architecture.ViewState<LoginPage, LoginController> {
  LoginPageState() : super(LoginController(DataAuthenticationRepository()));

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: ControlledWidgetBuilder<LoginController>(builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
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
                onPressed: controller.isLoggingIn ? null : () => controller.login(_emailController.text, _passwordController.text),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 5),
                child: controller.isLoggingIn
                    ? const CircularProgressIndicator()
                    : controller.isAuthenticated
                        ? const Text('Succesfully logged in!')
                        : const Text('Login'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
