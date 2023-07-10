import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/dialogs.dart';
import 'package:flutter_application_1/friend_page.dart';
import 'package:flutter_application_1/group.dart';
import 'package:flutter_application_1/kakao_login.dart';
import 'package:flutter_application_1/subject.dart';
import 'package:flutter_application_1/timer_page.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'main_view_model.dart';

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
  Subject currentSubject = Subject('');
  DateTime? currentStart;
  List<Subject> subjects = getSubjectListFromServer();
  List<Group> groups = getGroupListFromServer();
  Group friends = Group(0, '친구', getFriendListFromServer());
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

  Group? getGroup() {
    if (currentGroup == null) {
      currentGroup = friends;
    }
    return currentGroup;
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
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      duration = stopwatch.elapsed;
      notifyListeners();
    });
  }

  void pause() {
    timer?.cancel();
    sendRecordToServer(currentStart!, DateTime.now(), currentSubject);
    stopwatch.stop();
  }
}

void updateFriendsState (appState) {
  appState.friends.members = getFriendListFromServer();
  appState.groups = getGroupListFromServer();
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AddType { enterGroup, makeGroup, addFriend }

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  final viewModel = MainViewModel(KakaoLogin());
  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    return GestureDetector(
      onTap: () {
        print('tap');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('몰품타'),
            actions: _selectedIndex == 2
                ? [
                    PopupMenuButton<AddType>(
                      onSelected: (AddType result) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            if (result == AddType.enterGroup) {
                              return InsertDialogUI(addNameArr: enterGroup, title: '그룹 가입', hint: '가입할 그룹 아이디를 입력하세요.');
                            }
                            else if (result == AddType.makeGroup) {
                              return InsertDialogUI(addNameArr: makeGroup, title: '그룹 생성', hint: '그룹 이름을 입력하세요.');
                            }
                            else {
                              return InsertDialogUI(addNameArr: addFriend, title: '친구 추가', hint: '친구 아이디를 입력하세요.');
                            }
                          },
                        );
                      },
                      itemBuilder: (BuildContext buildContext) {
                        return [
                          PopupMenuItem(
                            value: AddType.enterGroup,
                            child: Text('그룹 가입'),
                          ),
                          PopupMenuItem(
                            value: AddType.makeGroup,
                            child: Text('그룹 생성'),
                          ),
                          PopupMenuItem(
                            value: AddType.addFriend,
                            child: Text('친구 추가'),
                          ),
                        ];
                      },
                    )
                  ]
                : null),
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
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          ],
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
        //List item index로 Body 변경
        body: viewModel.getUser() != null
            ? Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
                  },
                  child: const Text('카카오'),
                ),
              ),
        floatingActionButton: _selectedIndex == 2
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    updateFriendsState(appState);
                  });
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
