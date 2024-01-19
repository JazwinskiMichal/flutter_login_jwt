import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/domain/repositories/authentication_repository.dart';
import 'package:http/http.dart' as http;

class RequestAccessTokenUseCase extends UseCase<
    RequestAccessTokenUseCaseResponse, RequestAccessTokenUseCaseParams> {
  final AuthenticationRepository _authenticationRepository;

  RequestAccessTokenUseCase(this._authenticationRepository);

  @override
  Future<Stream<RequestAccessTokenUseCaseResponse?>> buildUseCaseStream(
      RequestAccessTokenUseCaseParams? params) async {
    final controller = StreamController<RequestAccessTokenUseCaseResponse?>();

    try {
      // Check if params is null
      if (params == null) {
        throw ArgumentError('params cannot be null');
      }

      http.Response response = await _authenticationRepository
          .requestAccessToken(params.email, params.password);

      controller.add(RequestAccessTokenUseCaseResponse(response));
      logger.finest('RequestAccessTokenUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('RequestAccessTokenUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class RequestAccessTokenUseCaseParams {
  final String email;
  final String password;

  RequestAccessTokenUseCaseParams(this.email, this.password);
}

class RequestAccessTokenUseCaseResponse {
  final http.Response response;
  RequestAccessTokenUseCaseResponse(this.response);
}
