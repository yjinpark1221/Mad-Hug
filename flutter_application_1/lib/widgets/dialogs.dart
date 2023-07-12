import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/functions/utils.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:provider/provider.dart';


class DialogUI extends StatelessWidget {
  const DialogUI({Key? key, this.title, this.msg, this.friendState})  : super(key: key);
  final title; // 부모 위젯으로부터 전달받은 변수 등록
  final msg; // 부모 위젯으로부터 전달받은 변수 등록
  final FriendState? friendState;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.white,
      //Dialog Main Title
      title: Column(
        children: <Widget>[
          Text(title),
        ],
      ),
      //
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            msg,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            return Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (title == '그룹 탈퇴') {
              sendDeleteGroup(friendState!.currentGroup!.id, friendState!);
            }
            return Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
 
class InsertDialogUI extends StatelessWidget {
  InsertDialogUI({Key? key, required this.addNameArr, required this.title, required this.hint}) : super(key: key);
  final addNameArr; // 입력 받은 값으로 호출할 함수
  final String title;
  final String hint;
  final _textFieldController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            addNameArr(_textFieldController.text);
            Navigator.pop(context);
          },
          child: Text('OK'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
