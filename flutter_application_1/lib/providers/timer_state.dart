
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:flutter_application_1/functions/utils.dart';

class TimerState extends ChangeNotifier {
  Timer? timer = null;
  final stopwatch = Stopwatch();
  var duration = Duration.zero;
  late Subject currentSubject;
  DateTime? currentStart;
  List<Subject> subjects = [];
  Subject? editingSubject = null;
  bool isAdding = false;

  Future init() async {
    print('?');
    subjects = await getSubjectsList();
    currentSubject = subjects[0];
    notifyListeners();
  }

  void edit(Subject subject) {
    if (editingSubject != null) throw Exception('이미 편집 중인 과목 있음');
    editingSubject = subject;
    notifyListeners();
  }

  void editDone() {
    // if (editingSubject == null) throw Exception('편집 중인 과목 없음');
    editingSubject?.editDone();
    editingSubject = null;
    notifyListeners();
  }
  void setSubjectList(List<Subject> subjectList) {
    subjects = subjectList;
    notifyListeners();
  }
  void setSubject(Subject subject) {
    if (stopwatch.isRunning && currentSubject == subject) {
      return;
    }
    if (stopwatch.isRunning) {
      pause();
    }
    currentSubject = subject;
    start();
    notifyListeners();
  }

  void start() {
    if (stopwatch.isRunning) return;
    stopwatch.start();
    currentStart = DateTime.now();
    sendStart(currentStart!, currentSubject);
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      duration = stopwatch.elapsed;
      notifyListeners();
    });
  }

  void pause() {
    if (stopwatch.isRunning == false) return;
    timer?.cancel();
    sendEnd(currentStart!, DateTime.now(), currentSubject);
    stopwatch.stop();
  }
}
