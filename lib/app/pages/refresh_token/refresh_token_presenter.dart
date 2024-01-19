import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_login_jwt/domain/usecases/refresh_token_usecase.dart';

class RefreshTokenPresenter extends Presenter {
  Function? onRefreshSuccess;
  Function? onRefreshFailed;

  final RefreshTokenUseCase refreshTokenUseCase;
  RefreshTokenPresenter(authenticationRepo)
      : refreshTokenUseCase = RefreshTokenUseCase(authenticationRepo);

  void refreshAccessToken() {
    refreshTokenUseCase.execute(_RefreshTokenUseCaseObserver(this));
  }

  @override
  void dispose() {
    refreshTokenUseCase.dispose();
  }
}

class _RefreshTokenUseCaseObserver
    extends Observer<RefreshTokenUseCaseResponse> {
  final RefreshTokenPresenter presenter;
  _RefreshTokenUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.onRefreshFailed!(e);
  }

  @override
  void onNext(response) {
    if (response?.response.statusCode == 200) {
      presenter.onRefreshSuccess!(response?.response);
    }
  }
}
