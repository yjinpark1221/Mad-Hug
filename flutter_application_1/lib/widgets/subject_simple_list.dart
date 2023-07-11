import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:flutter_application_1/functions/toast.dart';
import 'package:flutter_application_1/functions/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/timer_state.dart';

class SubjectSimpleList extends StatefulWidget {
  @override
  _SubjectSimpleList createState() => _SubjectSimpleList();
}

class _SubjectSimpleList extends State<SubjectSimpleList> {
  TextEditingController _textEditingController = TextEditingController();
  Subject? editingSubject = null;
  TimerState? timerState = null;
  FocusNode addFocusNode = FocusNode();
  bool isAdding = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    timerState = null;
  }



  @override
  Widget build(BuildContext context) {
    timerState = context.watch<TimerState>();
    final tileHeight = 55.0;
    final textFieldHeight = 45.0;
    final contentPadding =
          EdgeInsets.symmetric(vertical: (tileHeight - textFieldHeight) / 2);
  
  void addItem(String value) {
    if (value == '') return;
    if (timerState == null) return;
    setState(() {
      var newSubject = Subject(0, value);
      timerState?.subjects.add(newSubject);
      sendNewSubject(newSubject.id, newSubject.getName());
      timerState?.isAdding = false;
      _textEditingController.text = '';
    });
  }

    return WillPopScope(
      onWillPop: () async {
        print('unfocus');
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          timerState!.isAdding = false;
          timerState!.editDone();
        });
        return false;
      },
      child: ListView.builder(
        itemCount: timerState!.subjects.length + 1,
        itemBuilder: (context, index) {
          // 새 과목
          if (index == timerState!.subjects.length) {
            if (timerState?.editingSubject == null) {
              // 과목 편집 안하고 있으면 추가란 보이게
              return Container(
                height: tileHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
                      Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.0),
                    ],
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      timerState!.isAdding = true;
                      addFocusNode.requestFocus();
                    });
                  },
                  leading: Icon(Icons.add),
                  title: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.grey, // 커서 색상을 검은색으로 설정
                    cursorWidth: 2.0,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      contentPadding: contentPadding,
                      focusedBorder: InputBorder.none,
                      focusColor: Colors.white,
                    ),
                    enabled: timerState!.isAdding &&
                        timerState!.editingSubject == null,
                    onFieldSubmitted: addItem,
                    autofocus: true, // 자동 포커스 비활성화
                    focusNode: addFocusNode, // 포커스 노드 연결
                  ),
                ),
              );
            }
            // 편집 중이면 추가란 안 보이게
            else {
              return null;
            }
          } else {
            // 일반 과목
            return Container(
              height: tileHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.0),
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  ],
                ),
              ),
              child: SubjectTile(
                  timerState: timerState!,
                  subject: timerState!.subjects[index]),
            );
          }
        },
      ),
    );
  }
}

class SubjectTile extends StatefulWidget {
  SubjectTile({
    super.key,
    required this.timerState,
    required this.subject,
  });

  final TimerState timerState;
  final Subject subject;

  @override
  State<SubjectTile> createState() => _SubjectTileState();
}

class _SubjectTileState extends State<SubjectTile> {
  FocusNode _textFocusNode = FocusNode();
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController =
        TextEditingController(text: widget.subject.getName());
  }

  @override
  void dispose() {
    super.dispose();
    _textFocusNode.dispose();
    textEditingController.dispose();
  }

  void editName(String value) {
    setState(() {
      widget.subject.setName(value);
    });
  }

  void editDone() {
    print('editDone!');
    setState(() {
      widget.timerState.editDone();
      widget.timerState.editingSubject = null;
      _textFocusNode.unfocus();
    });
  }

  void startEditing() {
    setState(() {
      widget.timerState.editingSubject = widget.subject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ListTile(
        leading: Icon(Icons.play_arrow),
        title: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: textEditingController,
          cursorColor: Colors.white, // 커서 색상을 검은색으로 설정
          cursorWidth: 1.0,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            // contentPadding: contentPadding,
          ),
          enabled: widget.subject.isEditing(),
          onChanged: editName,
          onEditingComplete: editDone,
          autofocus: true, // 자동 포커스 비활성화
          focusNode: _textFocusNode, // 포커스 노드 연결
        ),
        onTap: () {
          widget.timerState.setSubject(widget.subject);
          print(widget.timerState.currentSubject.getName());
        },
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: widget.timerState.editingSubject != null
              ? () {
                  showToast('편집중인 과목이 있습니다.');
                }
              : () {
                  showToast('편집을 시작합니다.');
                  setState(() {
                    widget.timerState.edit(widget.subject);
                    widget.subject.edit();
                    _textFocusNode.requestFocus();
                  });
                },
        ),
      ),
    );
  }
}
