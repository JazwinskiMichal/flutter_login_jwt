class TemplateVersion {
  final String id;
  final String description;
  final String namingSchema;

  TemplateVersion({
    required this.id,
    required this.description,
    required this.namingSchema,
  });

  TemplateVersion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        namingSchema = json['namingSchema'];
}
