import 'package:flutter/material.dart';
import 'package:flutter_application_1/subject.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupList createState() => _GroupList();
}

class _GroupList extends State<GroupList> {
  TextEditingController _textEditingController = TextEditingController();
  bool isEditing = false;
  FocusNode _textFocusNode = FocusNode(); // 포커스 노드 추가
  Subject? editingSubject = null;
  MyAppState? appState = null;

  @override
  void initState() {
    super.initState();
  }

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
      appState?.subjects.add(Subject(-1, value));

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

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();

    return Container(
      height: 70,
      child: ListView.builder(
        itemCount: appState!.groups.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GroupTile(
              appState: appState!,
              index: index,
              child: Text('친구'),
            );
          } else if (index <= appState!.groups.length) {
            return GroupTile(
              appState: appState!,
              index: index,
              child: Text(
                appState!.groups[index - 1].getName(),
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
    required this.appState,
    required this.child,
    required this.index,
  });

  final MyAppState appState;
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
            onPressed: appState.currentGroup == appState.getGroupOfIndex(index) ? null : () {
              appState.setGroup(index);
            },
            
          ),
        ),
      ),
    );
  }
}
