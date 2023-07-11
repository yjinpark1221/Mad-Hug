import 'package:flutter/material.dart';


class DialogUI extends StatelessWidget {
  const DialogUI({Key? key, this.Cnt, this.Name}) : super(key: key);
  final Cnt; // 부모 위젯으로부터 전달받은 변수 등록
  final Name; // 부모 위젯으로부터 전달받은 변수 등록
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.white,
      //Dialog Main Title
      title: Column(
        children: <Widget>[
          Text("팝업 메시지"),
        ],
      ),
      //
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "카운트 횟수 ${Cnt}, 이름 : ${Name}",
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'OK'),
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
