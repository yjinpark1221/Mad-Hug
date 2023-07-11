import 'package:flutter/material.dart';
import 'package:flutter_application_1/group.dart';
import 'package:flutter_application_1/subject.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendList createState() => _FriendList();
}

class _FriendList extends State<FriendList> {
  TextEditingController _textEditingController = TextEditingController();
  bool isEditing = false;
  FocusNode _textFocusNode = FocusNode(); // 포커스 노드 추가
  Subject? editingSubject = null;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textFocusNode.dispose(); // 포커스 노드 해제
  }

  Group getGroup(FriendState friendState) {
    if (friendState.getGroup() == null) {
      friendState.setGroup(0);
    }
    return friendState.currentGroup!;
  }

  @override
  Widget build(BuildContext context) {
    FriendState friendState = context.watch<FriendState>();

    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: getGroup(friendState).members.length,
        itemBuilder: (context, index) {
          Friend friend = getGroup(friendState).members[index];
          return FriendTile(
            friendState: friendState,
            child: Text(
              '${friend.getName()} ${friend.isStudying ? ' 몰입 중' : ' 휴식 중'}'
            ),
          );
        },
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  const FriendTile({
    super.key,
    required this.friendState,
    required this.child,
  });

  final FriendState? friendState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListTile(
        contentPadding: EdgeInsets.zero, // contentPadding 제거
        title: Container(
          width: double.infinity, // 버튼이 ListTile의 가로 공간을 가득 채울 수 있도록 설정
          height: 40,
          child: ElevatedButton(
            child: child,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
