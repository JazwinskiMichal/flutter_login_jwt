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
          return Scrollbar(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: controller.templates.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.templates[index].id),
                      subtitle: Text(controller.templates[index].name),
                    );
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
