import 'package:flutter_application_1/utils.dart';

class Subject {
  static int cnt = 0;
  int id = 0;
  String _name;
  bool _isEditing = false;

  Subject(this.id, this._name) {
    if (_name == '') {
      _name = '자습';
    }
    if (id > 0) {
      cnt = id + 1;
    }
    else {
      id = cnt++;
    }
  }

  void setName(String name) {
    _name = name;
  }

  String getName() {
    return _name;
  }

  void edit() {
    _isEditing = true;
  }

  bool isEditing() {
    return _isEditing;
  }

  void editDone() {
    sendEditedSubject(id, _name);
    _isEditing = false;
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      json['subjectId'],
      json['subjectName'],
    );
  }
}
