import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/subject_simple_list.dart';
import 'package:flutter_application_1/time_widget.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  var icon = null;

  bool listOpen = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      icon = Icon(Icons.play_arrow);
    });
  }

  void openList() {}

  void closeList() {}

  @override
  Widget build(BuildContext context) {
    TimerState timerState = context.watch<TimerState>();
    if (timerState.stopwatch.isRunning) {
      icon = Icon(Icons.pause);
    } else {
      icon = Icon(Icons.play_arrow);
    }

    void toggle() {
      if (timerState.isOn) {
        timerState.pause();
        timerState.isOn = false;
        setState(() {
          icon = Icon(Icons.pause);
        });
      } else {
        timerState.isOn = true;
        timerState.start();
        setState(() {
          icon = Icon(Icons.play_arrow);
        });
      }
    }

    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onSecondary,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          icon: icon,
          iconSize: 100,
          onPressed: () {
            toggle();
          },
        ),
        TimeWidget(duration: timerState.duration),
        Spacer(),
        GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 0) {
              print('Swipe down');
              if (listOpen == true) {
                // test();
                setState(() {
                  listOpen = false;
                });
                closeList();
              }
            } else if (details.delta.dy < -0) {
              print('Swipe up');
              if (listOpen == false) {
                setState(
                  () {
                    listOpen = true;
                    print('openlist');
                  },
                );
                openList();
              }
            }
          },
          child: Container(
            // width: 200,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0,
                  0.1,
                  0.9,
                ],
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0),
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timerState.currentSubject.getName(),
                    style: style,
                  ),
                  Text(
                    timerState.currentSubject.getName() == '' ? '' : '에 몰입 중',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          // 속도
          duration: Duration(seconds: 1),
          // animation 형태
          curve: Curves.fastOutSlowIn,
          width: double.infinity,
          // 컨테이너의 가로 사이즈
          height: listOpen ? 350 : 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: SubjectSimpleList(),
        )
      ],
    );
  }
}
