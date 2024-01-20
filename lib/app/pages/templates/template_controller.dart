import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/app/pages/templates/templates_presenter.dart';
import 'package:flutter_login_jwt/domain/entities/templates/template.dart';

class TemplatesController extends Controller {
  final ScrollController scrollController = ScrollController();
  final TemplatesPresenter templatesPresenter;
  List<Template> templates = [];
  int currentPage = 1;
  bool isLoading = false;

  TemplatesController(templatedRepo)
      : templatesPresenter = TemplatesPresenter(templatedRepo),
        super();

  void getTemplates() {
    isLoading = true;
    refreshUI();
    templatesPresenter.getTemplates(20, currentPage);
  }

  void onScrollEnd() {
    if (!isLoading) {
      currentPage++;
      getTemplates();
    }
  }

  @override
  void initListeners() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });

    // Get templates
    getTemplates();

    templatesPresenter.onGetTemplatesSuccess = (List newTemplates) {
      templates.addAll(newTemplates as Iterable<Template>);
      isLoading = false;
      refreshUI();
    };

    templatesPresenter.onGetTemplatesFailed = (e) {
      print('TemplatesController: onGetTemplatesFailed');
      isLoading = false;
      refreshUI();
    };
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDisposed() {
    templatesPresenter.dispose();
    super.onDisposed();
  }
}
