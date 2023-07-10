import 'kakao_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';


class MainViewModel {
  final KakaoLogin _kakaoLogin;
  OAuthToken? token = null;
  bool isLoggedIn = false;

  MainViewModel(this._kakaoLogin);

  Future login() async {
    token = await _kakaoLogin.login();
    if (token != null) {
      isLoggedIn = true;
    }
    if (isLoggedIn) {
      await UserApi.instance.me();
      print(isLoggedIn);
    }
  }
  Future logout() async {
    await _kakaoLogin.logout();
    isLoggedIn = false;
  }
  
  User? getUser() {
    return _kakaoLogin.getUser();
  }
}