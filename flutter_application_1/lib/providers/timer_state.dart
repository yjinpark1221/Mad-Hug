
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:flutter_application_1/functions/utils.dart';

class TimerState extends ChangeNotifier {
  bool isOn = false;
  Timer? timer = null;
  final stopwatch = Stopwatch();
  var duration = Duration.zero;
  Subject currentSubject = Subject(-1, '');
  DateTime? currentStart;
  List<Subject> subjects = [];
  Subject? editingSubject = null;
  bool isAdding = false;

  Future init() async {
    print('?');
    subjects = await getSubjectsList();
    notifyListeners();
  }

  void edit(Subject subject) {
    if (editingSubject != null) throw Exception('이미 편집 중인 과목 있음');
    editingSubject = subject;
    notifyListeners();
  }

  void editDone() {
    // if (editingSubject == null) throw Exception('편집 중인 과목 없음');
    editingSubject!.editDone();
    editingSubject = null;
    notifyListeners();
  }

  void setSubject(Subject subject) {
    if (stopwatch.isRunning && currentSubject == subject) {
      return;
    }
    if (stopwatch.isRunning) {
      pause();
    }
    start();
    currentSubject = subject;
    notifyListeners();
  }

  void start() {
    print('start');
    stopwatch.start();
    currentStart = DateTime.now();
    sendStart(currentStart!, currentSubject);
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      duration = stopwatch.elapsed;
      notifyListeners();
    });
  }

  void pause() {
    timer?.cancel();
    sendEnd(currentStart!, DateTime.now(), currentSubject);
    stopwatch.stop();
  }
}
