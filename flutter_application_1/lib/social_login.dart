import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class SocialLogin {
  Future<OAuthToken?> login();
  Future<bool> logout();
}