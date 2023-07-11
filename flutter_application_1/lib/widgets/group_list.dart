import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupList createState() => _GroupList();
}

class _GroupList extends State<GroupList> {
  TextEditingController _textEditingController = TextEditingController();
  bool isEditing = false;
  FocusNode _textFocusNode = FocusNode(); // 포커스 노드 추가
  Subject? editingSubject = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textFocusNode.dispose(); // 포커스 노드 해제
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = context.watch<UserState>();
    TimerState timerState = context.watch<TimerState>();
    FriendState friendState = context.watch<FriendState>();

    return Container(
      height: 70,
      child: ListView.builder(
        itemCount: friendState.groups.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GroupTile(
              friendState: friendState,
              index: index,
              child: Text('친구'),
            );
          } else if (index <= friendState.groups.length) {
            return GroupTile(
              friendState: friendState,
              index: index,
              child: Text(
                friendState.groups[index - 1].getName(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.friendState,
    required this.child,
    required this.index,
  });

  final FriendState friendState;
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ListTile(
        contentPadding: EdgeInsets.zero, // contentPadding 제거
        title: Container(
          width: double.infinity, // 버튼이 ListTile의 가로 공간을 가득 채울 수 있도록 설정
          height: 60,
          child: ElevatedButton(
            child: child,
            style: ElevatedButton.styleFrom(
              disabledForegroundColor: Colors.green,
              disabledBackgroundColor: Colors.grey[300],
            ),
            onPressed: friendState.currentGroup == friendState.getGroupOfIndex(index) ? null : () {
              friendState.setGroup(index);
            },
            
          ),
        ),
      ),
    );
  }
}
