import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart' as clean_architecture;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/templates/template_controller.dart';
import 'package:flutter_login_jwt/data/repositories/data_templates_repository.dart';

class TemplatesPage extends clean_architecture.View {
  const TemplatesPage({super.key});

  @override
  TemplatesPageState createState() => TemplatesPageState();
}

class TemplatesPageState extends clean_architecture.ViewState<TemplatesPage, TemplatesController> {
  TemplatesPageState() : super(TemplatesController(DataTemplatesRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      body: ControlledWidgetBuilder<TemplatesController>(
        builder: (context, controller) {
          final List<Widget> templateWidgets = controller.templates.map((template) {
            return ListTile(
              title: Text(template.id),
              subtitle: Text(template.name),
            );
          }).toList();

          return Scrollbar(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: templateWidgets.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    return templateWidgets[index];
                  },
                ),
                if (controller.isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
