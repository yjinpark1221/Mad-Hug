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
  MyAppState? appState = null;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textFocusNode.dispose(); // 포커스 노드 해제
    appState = null;
  }

  void addItem(String value) {
    if (value == '') return;
    setState(() {
      appState?.subjects.add(Subject(value));
      isEditing = false;
      _textEditingController.clear();
    });
  }

  void editItem(String value) {
    setState(() {
      editingSubject?.setName(value);
    });
  }

  void editDone() {
    setState(() {
      editingSubject?.editDone();
      editingSubject = null;
    });
  }

  Group getGroup(MyAppState appState) {
    if (appState.getGroup() == null) {
      appState.setGroup(0);
    }
    return appState.currentGroup!;
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();

    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: getGroup(appState!).members.length,
        itemBuilder: (context, index) {
          Friend friend = getGroup(appState!).members[index];
          return FriendTile(
            appState: appState,
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
    required this.appState,
    required this.child,
  });

  final MyAppState? appState;
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
