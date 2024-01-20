import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/domain/repositories/authentication_repository.dart';
import 'package:http/http.dart' as http;

class RefreshTokenUseCase extends UseCase<RefreshTokenUseCaseResponse, void> {
  final AuthenticationRepository _authenticationRepository;

  RefreshTokenUseCase(this._authenticationRepository);

  @override
  Future<Stream<RefreshTokenUseCaseResponse?>> buildUseCaseStream(void params) async {
    final controller = StreamController<RefreshTokenUseCaseResponse>();

    try {
      http.Response response = await _authenticationRepository.refreshAccessToken();

      await Future.delayed(const Duration(seconds: 1));

      controller.add(RefreshTokenUseCaseResponse(response));

      if (response.statusCode == 200) {
        // Save the new token
        await _authenticationRepository.saveAccessToken(response.body);
        logger.finest('RefreshTokenUseCase successful.');
        controller.close();
      } else {
        logger.severe('RefreshTokenUseCase unsuccessful.');
        controller.addError(response.statusCode);
      }
    } catch (e) {
      logger.severe('RefreshTokenUseCase exception.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class RefreshTokenUseCaseResponse {
  final http.Response response;
  RefreshTokenUseCaseResponse(this.response);
}
