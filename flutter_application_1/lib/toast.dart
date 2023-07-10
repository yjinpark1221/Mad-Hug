import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text) {
      Fluttertoast.showToast(
        msg: text, // 필수! 띄울 메세지
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromARGB(255, 65, 104, 136), // toast 색상
        textColor: Colors.white, // toast 글씨 색상
        fontSize: 15.0, // toast 글씨 크기
    );
}