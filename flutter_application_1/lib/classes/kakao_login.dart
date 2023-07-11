import "package:flutter_application_1/social_login.dart";
import "package:kakao_flutter_sdk/kakao_flutter_sdk.dart";

User? user = null;

class KakaoLogin implements SocialLogin {

  @override
  Future<OAuthToken?> login() async {
    bool isInstalled = await isKakaoTalkInstalled();
    OAuthToken? token = null;

    if (isInstalled) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        return null;
      }
    }
    else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return null;
      }
    }
    try {
      await refreshUser();      
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
      return null;
    }
    return token;
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (e) {
      return false;
    }
  }
  User? getUser() {
    return user;
  }
  Future refreshUser() async {
    user = await UserApi.instance.me();
    print('사용자 닉네임: ${user?.kakaoAccount?.profile?.nickname}');
    print('사용자 ID: ${user?.id}');
  }
}