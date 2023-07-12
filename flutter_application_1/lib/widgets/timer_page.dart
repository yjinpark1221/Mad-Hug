import 'package:flutter/material.dart';
import 'package:flutter_application_1/functions/toast.dart';
import 'package:flutter_application_1/widgets/subject_simple_list.dart';
import 'package:flutter_application_1/widgets/time_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/timer_state.dart';

class TimerPage extends StatefulWidget {
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  var icon = null;
  var keyboardheight = 0.0;
  bool listOpen = false;
  Icon playIcon = Icon(
    Icons.play_arrow,
    shadows: <Shadow>[
      Shadow(
        color: Color.fromARGB(60, 92, 92, 92),
        blurRadius: 30.0,
      )
    ],
  );
  Icon pauseIcon = Icon(
    Icons.pause,
    shadows: <Shadow>[
      Shadow(
        color: Color.fromARGB(111, 255, 255, 255),
        blurRadius: 30.0,
      ),
    ],
  );
  @override
  void initState() {
    super.initState();
    setState(() {
      icon = Icon(
        Icons.play_arrow,
      );
    });
  }

  @override
  void didChangeMetrics() {
    final bottom = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      this.keyboardheight = bottom;
      showToast('$keyboardheight');
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerState timerState = context.watch<TimerState>();
    if (timerState.stopwatch.isRunning) {
      icon = pauseIcon;
    } else {
      icon = playIcon;
    }

    void toggle() {
      if (timerState.stopwatch.isRunning) {
        timerState.pause();
        setState(() {
          icon = pauseIcon;
        });
      } else {
        timerState.start();
        setState(() {
          icon = playIcon;
        });
      }
    }

    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: timerState.stopwatch.isRunning
            ? Color.fromARGB(255, 59, 67, 116)
            : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          IconButton(
            icon: icon,
            iconSize: 100,
            color: timerState.stopwatch.isRunning
                ? Colors.white
                : Color.fromARGB(255, 25, 29, 51),
            onPressed: () {
              toggle();
            },
          ),
          TimeWidget(
            duration: timerState.duration,
            color: timerState.stopwatch.isRunning
                ? Colors.white
                : Color.fromARGB(255, 32, 35, 63),
          ),
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
                    0.5,
                    0.9,
                  ],
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primaryContainer,
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
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                      ),
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
            height: listOpen
                ? MediaQuery.of(context).size.height - 405 - keyboardheight
                : 0,
            // animation 형태
            curve: Curves.fastOutSlowIn,
            width: double.infinity,
            // 컨테이너의 가로 사이즈
            color: Theme.of(context).colorScheme.primaryContainer,
            child: SubjectSimpleList(),
          )
        ],
      ),
    );
  }
}
