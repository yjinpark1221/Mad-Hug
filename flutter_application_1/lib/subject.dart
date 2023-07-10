import 'package:flutter_application_1/utils.dart';

class Subject {
  int id = -1;
  String _name;
  bool _isEditing = false;

  Subject(this._name) {
    if (_name == '') {
      _name = '자습';
    }
    id = sendNewSubjectToServer(_name, id);
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
    sendSubjectNameToServer(_name, id);
    _isEditing = false;
  }
}