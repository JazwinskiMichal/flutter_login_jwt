import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/data/api_constants.dart';
import 'package:flutter_login_jwt/data/repositories/data_authentication_repository.dart';
import 'package:flutter_login_jwt/domain/entities/templates/template.dart';
import 'package:flutter_login_jwt/domain/repositories/templates_repository.dart';

class GetTemplatesUseCase extends UseCase<GetTemplatesUseCaseResponse, GetTemplatedUseCaseParams> {
  final TemplatesRepository _templatesRepository;

  GetTemplatesUseCase(this._templatesRepository);

  @override
  Future<Stream<GetTemplatesUseCaseResponse?>> buildUseCaseStream(GetTemplatedUseCaseParams? params) async {
    final controller = StreamController<GetTemplatesUseCaseResponse>();

    try {
      // TODO: Check if token is expired, if so, refresh it
      final accessToken = await storage.read(key: storageTokenKey);
      final templates = await _templatesRepository.getTemplates(params!.collectionSize, params.page, accessToken!);

      controller.add(GetTemplatesUseCaseResponse(templates));

      logger.finest('GetTemplatesUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetTemplatesUseCase exception.');
      controller.addError(e);
    }

    return controller.stream;
  }
}

class GetTemplatedUseCaseParams {
  final int collectionSize;
  final int page;

  GetTemplatedUseCaseParams({required this.collectionSize, required this.page});
}

class GetTemplatesUseCaseResponse {
  final List<Template> templates;
  GetTemplatesUseCaseResponse(this.templates);
}
