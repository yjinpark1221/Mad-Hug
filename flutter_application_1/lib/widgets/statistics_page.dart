import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/time_widget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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

  DateTime _now = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];
  final _events = LinkedHashMap(
    equals: isSameDay,
  )..addAll({
      DateTime(2023, 8, 15): Event(date: DateTime(2023, 8, 15), title: '광복절'),
      DateTime(2023, 6, 6): Event(date: DateTime(2023, 6, 6), title: '현충일'),
      DateTime(2023, 5, 5): Event(date: DateTime(2023, 5, 5), title: '어린이날'),
      // DateTime(2022, 8, 9) : Event(date: DateTime(2022, 8, 9)),
      // DateTime(2022, 8, 11) : Event(date: DateTime(2022, 8, 11)),
      // DateTime(2022, 8, 14) : Event(date: DateTime(2022, 8, 14)),
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Material(
          child: Column(
            children: [
              TableCalendar(
                locale: 'ko_KR',
                // 달에 첫 날
                firstDay: DateTime(_now.year - 2, 1, 1),
                // 달에 마지막 날
                lastDay: DateTime(_now.year + 2, 12, 31),
                focusedDay: _now,
                calendarFormat: _calendarFormat,
                daysOfWeekHeight: 30,
                // headerVisible: false,
                calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                )),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                // 사용자가 캘린더에 요일을 클릭했을 때
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _now = focusedDay;
                    });
                  }
                },
                // 캘린더의 포맷을 변경 (CalendarFormat.month 로 지정)
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  setState(() {
                    _now = focusedDay;
                    _selectedDay = _now;
                  });
                },

                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      return Center(
                        child: Text(
                          days[day.weekday],
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return Center(
                          child: Text(
                        days[day.weekday],
                      ));
                    }
                  },
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: _buildEventsMarker(date),
                      );
                    }
                    return null;

                    // DateTime _date = DateTime(date.year, date.month, date.day);
                    // print(_date);
                    // print(_events[_date]);
                    // if (_events[_date] != null &&
                    //     isSameDay(_date, _events[_date].date)) {
                    //   return Container(
                    //     width: double.infinity,
                    //     // decoration: const BoxDecoration(
                    //     //   color: Colors.lightBlue,
                    //     //   shape: BoxShape.circle,
                    //     // ),
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width * 0.03,
                    //       decoration: const BoxDecoration(
                    //           color: Colors.lightBlue,
                    //           shape: BoxShape.circle,
                    //           s),
                    //     ),
                    //   );
                    //   // child: Text(
                    //   //   '${_date.day}',
                    //   // ));
                    // } else
                    //   return null;
                  },
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMMd(locale).format(date),
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(
                    fontSize: 20.0,
                    // backgroundColor: Colors.blueGrey,
                    // color: Colors.white,
                  ),
                  // color: Colors.indigo,
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
              SizedBox(
                height: 10,
              ),
              Text('${_now.year}년 ${_now.month}월 ${_now.day}일 총 공부 시간'),
              TimeWidget(duration: Duration(), color: Colors.black),
              SizedBox(
                height: 10,
              ),
              Text('${_now.year}년 ${_now.month}월 총 공부 시간'),
              TimeWidget(duration: Duration(), color: Colors.black),
              SizedBox(
                height: 10,
              ),
              Text('누적 공부 시간'),
              TimeWidget(duration: Duration(), color: Colors.black),
            ],
          ),
          // TableCalendar(
          //   locale: 'ko_KR',
          //   firstDay: DateTime.utc(2021, 10, 16),
          //   lastDay: DateTime.utc(2030, 3, 14),
          //   focusedDay: DateTime.now(),
          //   // rangeEndDay: endDate,
          //   // rangeStartDay: startDate,
          //   calendarStyle: CalendarStyle(
          //     // holiday 글자 조정
          //     holidayTextStyle: const TextStyle(color: Color(0xFF5C6BC0)),

          //     // holiday 모양 조정
          //     holidayDecoration: const BoxDecoration(
          //       border: Border.fromBorderSide(
          //         BorderSide(color: const Color(0xFF9FA8DA), width: 1.4),
          //       ),
          //       shape: BoxShape.circle,
          //     ),

          //     // weekend 글자 조정
          //     weekendTextStyle:
          //         const TextStyle(color: Color.fromARGB(255, 112, 139, 215)),

          //     // weekend 모양 조정
          //     weekendDecoration: const BoxDecoration(shape: BoxShape.circle),

          //     // range 크기 조절
          //     rangeHighlightScale: 1.0,
          //     // t

          //     // range 색상 조정
          //     rangeHighlightColor: const Color(0xFFBBDDFF),
          //     // rangeStartDay 글자 조정
          //     rangeStartTextStyle: const TextStyle(
          //       color: const Color(0xFFFAFAFA),
          //       fontSize: 16.0,
          //     ),

          //     // rangeStartDay 모양 조정
          //     rangeStartDecoration: const BoxDecoration(
          //       color: const Color(0xFF6699FF),
          //       shape: BoxShape.circle,
          //     ),

          //     // rangeEndDay 글자 조정
          //     rangeEndTextStyle: const TextStyle(
          //       color: const Color(0xFFFAFAFA),
          //       fontSize: 16.0,
          //     ),

          //     // rangeEndDay 모양 조정
          //     rangeEndDecoration: const BoxDecoration(
          //       color: const Color(0xFF6699FF),
          //       shape: BoxShape.circle,
          //     ),

          //     // startDay, endDay 사이의 글자 조정
          //     withinRangeTextStyle: const TextStyle(),

          //     // startDay, endDay 사이의 모양 조정
          //     withinRangeDecoration:
          //         const BoxDecoration(shape: BoxShape.circle),
          //   ),
          //   // 추가
          //   headerStyle: HeaderStyle(
          //     titleCentered: true,
          //     titleTextFormatter: (date, locale) =>
          //         DateFormat.yMMMMd(locale).format(date),
          //     formatButtonVisible: false,
          //     titleTextStyle: const TextStyle(
          //       fontSize: 20.0,
          //       color: Colors.indigo,
          //     ),
          //     headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
          //     leftChevronIcon: const Icon(
          //       Icons.arrow_left,
          //       size: 40.0,
          //     ),
          //     rightChevronIcon: const Icon(
          //       Icons.arrow_right,
          //       size: 40.0,
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date) {
    final events = _events[date];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue.withOpacity(0.6),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

class Event {
  final DateTime date;
  String title;
  Event({required this.date, required this.title});
}
