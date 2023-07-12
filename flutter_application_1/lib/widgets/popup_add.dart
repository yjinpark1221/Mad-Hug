
import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/classes/kakao_login.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:flutter_application_1/widgets/dialogs.dart';
import 'package:flutter_application_1/widgets/friend_page.dart';
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

enum GroupOption { exitGroup, groupView, idView }

class PopupDelete extends StatelessWidget {
  final Group group;
  const PopupDelete({
    super.key,required this.group,required this.friendState
  });
  final FriendState friendState;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GroupOption>(
      onSelected: (GroupOption result) {
        showDialog(
          context: context,
          builder: (context) {
            if (result == GroupOption.exitGroup) {
              return DialogUI(title: '그룹 탈퇴', msg: '그룹을 탈퇴하시겠습니까?', friendState: friendState);
            }
            else if (result == GroupOption.groupView) {
              return DialogUI(title: '그룹 아이디 조회', msg: '${group.id}');
            } 
            else {
              return DialogUI(title: '내 아이디 조회', msg: '${user!.kakaoAccount?.profile?.nickname}의 아이디 : ${user?.id}');
            }
          },
        );
      },
      itemBuilder: (BuildContext buildContext) {
        return [
          PopupMenuItem(
            value: GroupOption.exitGroup,
            child: Text('그룹 탈퇴'),
          ),
          PopupMenuItem(
            value: GroupOption.groupView,
            child: Text('그룹 아이디 조회'),
          ),
          PopupMenuItem(
            value: GroupOption.idView,
            child: Text('내 아이디 조회'),
          ),
        ];
      },
    );
  }
}
