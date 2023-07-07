import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int timeCnt = 0;
  bool isOn = false;
  Timer? timer = null;
  final stopwatch = Stopwatch();
  var duration = Duration.zero;

  void start() {
    print('start');
    stopwatch.start();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      duration = stopwatch.elapsed;
      notifyListeners();
    });
  }

  void pause() {
    timer?.cancel();
    stopwatch.stop();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('몰품타'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          print('index test : $index');
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
        ],
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      //List item index로 Body 변경
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  List _widgetOptions = [
    Placeholder(),
    TimerPage(),
    Placeholder(),
  ];
}

class TimerPage extends StatefulWidget {
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  var currentSubjectIdx = -1;
  var icon = null;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> _items = [];
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
    var size = MediaQuery.of(context).size;

    var appState = context.watch<MyAppState>();
    if (appState.isOn) {
      icon = Icon(Icons.pause);
    } else {
      icon = Icon(Icons.play_arrow);
    }

    void toggle() {
      if (appState.isOn) {
        appState.pause();
        appState.isOn = false;
        setState(() {
          icon = Icon(Icons.pause);
        });
      } else {
        appState.isOn = true;
        appState.start();
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
        // DigitalClock(),
        IconButton(
            icon: icon,
            iconSize: 100,
            onPressed: () {
              toggle();
            }),
        TimeWidget(timeCnt: appState.duration),
        Spacer(),
        GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 0) {
              print('Swipe down');
              if (listOpen == true) {
                setState(() {
                  listOpen = false;
                });
                closeList();
              }
            } else if (details.delta.dy < -0) {
              print('Swipe up');
              if (listOpen == false) {
                setState(() {
                  listOpen = true;
                  print('openlist');
                });
                openList();
              }
            }
          },
          child: Container(
            // width: 200,
            height: 80,
            color: Theme.of(context).colorScheme.secondary,
            child: Center(
              child: Text(
                'Swipe me',
                style: style,
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
          color: Colors.blue,
        )
      ],
    );
  }
}

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _currentTime,
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('EEE, d MMM').format(DateTime.now()),
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
    required this.timeCnt,
  });

  final Duration timeCnt;

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Text(format(timeCnt),
        style: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ));
  }
}

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    return Center(
      child: Card(
        child: SizedBox(
          width: 100,
          height: 50,
          child: Center(child: Text(content, style: style)),
        ),
      ),
    );
  }
}

class SubjectList extends StatelessWidget {
  const SubjectList({
    super.key,
    required GlobalKey<AnimatedListState> listKey,
    required List<String> items,
  })  : _listKey = listKey,
        _items = items;

  final GlobalKey<AnimatedListState> _listKey;
  final List<String> _items;
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: animation,
            child: ListTile(
              title: Text(_items[index]),
            ),
          );
        });
  }
}
