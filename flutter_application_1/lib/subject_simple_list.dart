import 'package:flutter/material.dart';
import 'package:flutter_application_1/subject.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class SubjectSimpleList extends StatefulWidget {
  @override
  _SubjectSimpleList createState() => _SubjectSimpleList();
}

class _SubjectSimpleList extends State<SubjectSimpleList> {
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

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();
    final tileHeight = 55.0;
    final textFieldHeight = 45.0;
    final contentPadding =
        EdgeInsets.symmetric(vertical: (tileHeight - textFieldHeight) / 2);

    return ListView.builder(
      itemCount: appState!.subjects.length + 1,
      itemBuilder: (context, index) {
        // 새 과목
        if (index == appState!.subjects.length) {
          if (editingSubject == null) {
            // 과목 편집 안하고 있으면 추가란 보이게
            return Container(
              height: tileHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ],
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.add),
                title: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: contentPadding,
                  ),
                  onFieldSubmitted: addItem,
                ),
              ),
            );
          }
          // 편집 중이면 추가란 안 보이게
          else {
            return SizedBox();
          }
        } else {
          return Container(
            height: tileHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),

            // 일반 과목
            child: ListTile(
              leading: Icon(Icons.play_arrow),
              title: appState!.subjects[index].isEditing()
                  // 편집중인 과목
                  ? TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        contentPadding: contentPadding,
                      ),
                      onFieldSubmitted: editItem,
                      onChanged: editItem,
                      onEditingComplete: editDone,
                      autofocus: true, // 자동 포커스 비활성화
                      focusNode: _textFocusNode, // 포커스 노드 연결
                    )
                  // 저장된 과목
                  : Text(appState!.subjects[index].getName()),
              onTap: () {
                setState(() {
                  appState!.setSubject(appState!.subjects[index]);
                  print(appState!.currentSubject.getName());
                });
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  appState!.subjects[index].edit();
                  setState(() {
                    editingSubject = appState!.subjects[index];
                  });
                },
              ),
            ),
          );
        }
      },
    );
  }
}
