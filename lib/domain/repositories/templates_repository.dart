import 'package:flutter_login_jwt/domain/entities/templates/template.dart';

abstract class TemplatesRepository {
  Future<List<Template>> getTemplates(int collectionSize, int page, String accessToken);
}
