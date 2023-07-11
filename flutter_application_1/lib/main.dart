import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/friend_page.dart';
import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/classes/kakao_login.dart';
import 'package:flutter_application_1/widgets/popup_add.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:flutter_application_1/widgets/timer_page.dart';
import 'package:flutter_application_1/functions/utils.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'classes/main_view_model.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: '097e7cd9a62149718112d7dc7ab99d3e',
    javaScriptAppKey: '00488ce796cfafa104b7f20fc289bf01',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        // MultiProvider를 통해 변화에 대해 구독
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => UserState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => TimerState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => FriendState()),
        ],
        child: MyHomePage(),
      ),
    );
  }
}

class UserState extends ChangeNotifier {
  final viewModel = MainViewModel(KakaoLogin());
  Future init() async {
    await viewModel.login();
  }
}

class TimerState extends ChangeNotifier {
  bool isOn = false;
  Timer? timer = null;
  final stopwatch = Stopwatch();
  var duration = Duration.zero;
  Subject currentSubject = Subject(-1, '');
  DateTime? currentStart;
  List<Subject> subjects = [];

  Future init() async {
    print('?');
    subjects = await getSubjectsList();
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

class FriendState extends ChangeNotifier {
  List<Group> groups = [];
  Group friends = Group(0, '친구', []);
  Group? currentGroup = null;

  void setGroup(int index) {
    if (index == 0) {
      currentGroup = friends;
    } else if (index > 0) {
      currentGroup = groups[index - 1];
    } else {
      currentGroup = null;
    }
    notifyListeners();
  }

  Future init() async {
    groups = await getGroupsList();
    friends = Group(0, '친구', await getFriendsList());
    notifyListeners();
  }

  Group getGroupOfIndex(int index) {
    if (index == 0) {
      return friends;
    }
    return groups[index - 1];
  }

  Group? getGroup() {
    if (currentGroup == null) {
      currentGroup = friends;
    }
    return currentGroup;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AddType { enterGroup, makeGroup, addFriend }

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    UserState userState = context.watch<UserState>();
    TimerState timerState = context.watch<TimerState>();
    FriendState friendState = context.watch<FriendState>();
    return userState.viewModel.getUser() == null
        ? LoginPage()
        : GestureDetector(
            onTap: () {
              print('tap');
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                  title: Text('몰품타'),
                  actions: _selectedIndex == 2 ? [PopupAdd()] : null),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  print('index test : $index');
                  setState(
                    () {
                      _selectedIndex = index;
                    },
                  );
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: 'Statistics'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: 'Friends'),
                ],
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
              ),
              //List item index로 Body 변경
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              floatingActionButton: _selectedIndex == 2
                  ? FloatingActionButton(
                      onPressed: () {
                        friendState.init();
                      },
                      child: Icon(Icons.refresh),
                    )
                  : null,
            ),
          );
  }

  List _widgetOptions = [
    Placeholder(),
    TimerPage(),
    FriendPage(),
  ];
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    UserState userState = context.watch<UserState>();
    TimerState timerState = context.watch<TimerState>();
    FriendState friendState = context.watch<FriendState>();
    return Center(
      child: loading
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await userState.init();
                await timerState.init();
                await friendState.init();
              },
              child: const Text('카카오'),
            ),
    );
  }
}
