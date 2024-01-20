import 'dart:convert';

import 'package:flutter_login_jwt/data/api_constants.dart';
import 'package:flutter_login_jwt/domain/entities/templates/template.dart';
import 'package:flutter_login_jwt/domain/repositories/templates_repository.dart';
import 'package:http/http.dart' as http;

class DataTemplatesRepository extends TemplatesRepository {
  @override
  Future<List<Template>> getTemplates(int collectionSize, int page, String accessToken) async {
    final response = await http.get(
      Uri.parse('$templatesUrl?pageNumber=$page&pageSize=$collectionSize'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 500) {
      return [];
    } else if (response.statusCode == 400) {
      return [];
    } else if (response.statusCode == 204) {
      return [];
    }

    final res = jsonDecode(response.body) as List<dynamic>;
    final templates = res.map((x) => Template.fromJson(x as Map<String, dynamic>)).toList();

    return templates;
  }
}
