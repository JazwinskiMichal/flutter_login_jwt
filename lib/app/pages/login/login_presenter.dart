import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/domain/usecases/login_usecase.dart';

class LoginPresenter extends Presenter {
  Function? onLoginSuccess;
  Function? onLoginFailed;

  final LoginUseCase loginUseCase;
  LoginPresenter(authenticationRepo) : loginUseCase = LoginUseCase(authenticationRepo);

  void login(String email, String password) {
    loginUseCase.execute(_LoginUseCaseObserver(this), LoginUseCaseParams(email: email, password: password));
  }

  @override
  void dispose() {
    loginUseCase.dispose();
  }
}

class _LoginUseCaseObserver extends Observer<LoginUseCaseResponse> {
  final LoginPresenter presenter;
  _LoginUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.onLoginFailed!(e);
  }

  @override
  void onNext(response) {
    if (response?.response.statusCode == 200) {
      presenter.onLoginSuccess!(response?.response);
    }
  }
}
