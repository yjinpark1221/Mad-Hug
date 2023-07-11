
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dialogs.dart';
import 'package:flutter_application_1/friend_page.dart';
import 'package:flutter_application_1/main.dart';

class PopupAdd extends StatelessWidget {
  const PopupAdd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AddType>(
      onSelected: (AddType result) {
        showDialog(
          context: context,
          builder: (context) {
            if (result == AddType.enterGroup) {
              return InsertDialogUI(addNameArr: enterGroup, title: '그룹 가입', hint: '그룹 ID를 입력하세요.');
            }
            else if (result == AddType.makeGroup) {
              return InsertDialogUI(addNameArr: makeGroup, title: '그룹 생성', hint: '그룹 이름을 입력하세요.');
            }
            else {
              return InsertDialogUI(addNameArr: addFriend, title: '친구 추가', hint: '친구 ID를 입력하세요.');
            }
          },
        );
      },
      itemBuilder: (BuildContext buildContext) {
        return [
          PopupMenuItem(
            value: AddType.enterGroup,
            child: Text('그룹 가입'),
          ),
          PopupMenuItem(
            value: AddType.makeGroup,
            child: Text('그룹 생성'),
          ),
          PopupMenuItem(
            value: AddType.addFriend,
            child: Text('친구 추가'),
          ),
        ];
      },
    );
  }
}
