import 'dart:async';

import 'package:flutter_login_jwt/domain/repositories/authentication_repository.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LoginUseCase extends UseCase<LoginUseCaseResponse, LoginUseCaseParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<Stream<LoginUseCaseResponse?>> buildUseCaseStream(LoginUseCaseParams? params) async {
    final controller = StreamController<LoginUseCaseResponse>();

    try {
      final response = await _authenticationRepository.requestAccessToken(params!.email, params.password);

      controller.add(LoginUseCaseResponse(response));

      if (response.statusCode == 200) {
        // Save the new token
        await _authenticationRepository.saveAccessToken(response.body);
        logger.finest('LoginUseCase successful.');
        controller.close();
      } else {
        logger.severe('LoginUseCase unsuccessful.');
        controller.addError(response.statusCode);
      }
    } catch (e) {
      logger.severe('LoginUseCase exception.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class LoginUseCaseParams {
  final String email;
  final String password;

  LoginUseCaseParams({required this.email, required this.password});
}

class LoginUseCaseResponse {
  final http.Response response;
  LoginUseCaseResponse(this.response);
}
