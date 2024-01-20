// Model for Template
import 'package:flutter_login_jwt/domain/entities/templates/template_version.dart';

class Template {
  final String id;
  final String name;
  final DateTime addedDate;
  final String currentVersionId;
  final String defaultDirectoryId;
  final List<TemplateVersion> versions;

  Template({
    required this.id,
    required this.name,
    required this.addedDate,
    required this.currentVersionId,
    required this.defaultDirectoryId,
    required this.versions,
  });

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        addedDate = DateTime.parse(json['addedDate']),
        currentVersionId = json['curentVersionId'],
        defaultDirectoryId = json['defaultDirectoryId'],
        versions = (json['versions'] as List).map((x) => TemplateVersion.fromJson(x)).toList();

  @override
  String toString() => '${id}_$name';
}
