import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:flutter_application_1/widgets/friend_list.dart';
import 'package:flutter_application_1/widgets/group_list.dart';
import 'package:flutter_application_1/functions/toast.dart';
import 'package:flutter_application_1/functions/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPage();
}

class _StatisticsPage extends State<StatisticsPage> {
  // CalendarController _calendarController;
  // Map<DateTime, List<dynamic>> _events;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: TableCalendar (
        locale: 'ko_KR',
        firstDay: DateTime.utc(2021, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        // rangeEndDay: endDate,
        // rangeStartDay: startDate,
        calendarStyle: CalendarStyle(
          // holiday 글자 조정
          holidayTextStyle : const TextStyle(color: Color(0xFF5C6BC0)),

          // holiday 모양 조정
          holidayDecoration : const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: const Color(0xFF9FA8DA), width: 1.4),
            ),
            shape: BoxShape.circle,
          ),

          // weekend 글자 조정
          weekendTextStyle: const TextStyle(color: Color.fromARGB(255, 112, 139, 215)),

          // weekend 모양 조정
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          
          // range 크기 조절
          rangeHighlightScale: 1.0,
          // t

          // range 색상 조정
          rangeHighlightColor: const Color(0xFFBBDDFF),
          // rangeStartDay 글자 조정
          rangeStartTextStyle: const TextStyle(
            color: const Color(0xFFFAFAFA),
            fontSize: 16.0,
          ),

          // rangeStartDay 모양 조정
          rangeStartDecoration: const BoxDecoration(
            color: const Color(0xFF6699FF),
            shape: BoxShape.circle,
          ),

          // rangeEndDay 글자 조정
          rangeEndTextStyle: const TextStyle(
            color: const Color(0xFFFAFAFA),
            fontSize: 16.0,
          ),

          // rangeEndDay 모양 조정
          rangeEndDecoration: const BoxDecoration(
            color: const Color(0xFF6699FF),
            shape: BoxShape.circle,
          ),

          // startDay, endDay 사이의 글자 조정
          withinRangeTextStyle: const TextStyle(),

          // startDay, endDay 사이의 모양 조정
          withinRangeDecoration: const BoxDecoration(shape: BoxShape.circle),
        ),
        // 추가
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMMd(locale).format(date),
          formatButtonVisible: false,
          titleTextStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.indigo,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            size: 40.0,
          ),
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}


class Event {
  String title;

  Event(this.title);
}