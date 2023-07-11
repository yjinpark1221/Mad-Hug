
import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/kakao_login.dart';
import 'package:flutter_application_1/classes/main_view_model.dart';


class UserState extends ChangeNotifier {
  final viewModel = MainViewModel(KakaoLogin());
  Future init() async {
    await viewModel.login();
  }
}
