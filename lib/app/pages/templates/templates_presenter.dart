import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/domain/usecases/get_templates_usecase.dart';

class TemplatesPresenter extends Presenter {
  Function? onGetTemplatesComplete;
  Function? onGetTemplatesSuccess;
  Function? onGetTemplatesFailed;

  final GetTemplatesUseCase getTemplatesUseCase;
  TemplatesPresenter(templatesRepo) : getTemplatesUseCase = GetTemplatesUseCase(templatesRepo);

  void getTemplates(int collectionSize, int page) {
    getTemplatesUseCase.execute(_GetTemplatesUseCaseObserver(this), GetTemplatedUseCaseParams(collectionSize: collectionSize, page: page));
  }

  @override
  void dispose() {
    getTemplatesUseCase.dispose();
  }
}

class _GetTemplatesUseCaseObserver extends Observer<GetTemplatesUseCaseResponse> {
  final TemplatesPresenter presenter;
  _GetTemplatesUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    presenter.onGetTemplatesComplete!();
  }

  @override
  void onError(e) {
    presenter.onGetTemplatesFailed!(e);
  }

  @override
  void onNext(response) {
    presenter.onGetTemplatesSuccess!(response?.templates);
  }
}
