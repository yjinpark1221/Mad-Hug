import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/kakao_login.dart';
import 'package:flutter_application_1/classes/main_view_model.dart';

import '../functions/utils.dart';

class RecordState extends ChangeNotifier {
  List<Records> records = [];
  Map<DateTime, List<Event>> eventMap = {};

  Future init() async {
    records = await getRecords();
    print('update record length ${records.length}');
    eventMap.clear();

    for (Records record in records) {
      DateTime startDate = record.startDate;

      Event event = Event(record.subjectName, record.duration);

      if (eventMap.containsKey(startDate)) {
        // 같은 날짜에 이미 이벤트가 있는 경우, 기존 이벤트의 시간을 추가합니다.
        Event updatedEvent = Event(record.subjectName, event.duration);
        eventMap[startDate]?.add(updatedEvent);
        print('eventMap append');
      } else {
        // 새로운 날짜에 이벤트를 추가합니다.
        eventMap[startDate] = [event];
        print('eventMap new');
      }
    }
    notifyListeners();
  }
}


class UserState extends ChangeNotifier {
  final viewModel = MainViewModel(KakaoLogin());

  Future init() async {
    await viewModel.login();
  }
}

// Map<DateTime>List<Event>> kEvents = [];
class Records {
  DateTime startDate;
  Duration duration;
  int subjectId;
  String subjectName;

  Records(
      {required this.startDate,
      required this.duration,
      required this.subjectId,
      required this.subjectName});

  factory Records.fromJson(Map<String, dynamic> json) {
    int year = json['year'];
    int month = json['month'];
    int day = json['date'];
    int dur = json['duration'];
    DateTime dateTime = DateTime(year, month, day);
    return Records(
      startDate: dateTime,
      duration: Duration(seconds: dur),
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
    );
  }
}

/// Example event class.
class Event {
  String subjectName;
  Duration duration;
  Event(this.subjectName, this.duration);

  @override
  String toString() => '$subjectName ${duration.inSeconds} sec';
}
