import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/calendar_example.dart';
import 'package:flutter_application_1/widgets/friend_page.dart';
import 'package:flutter_application_1/widgets/popup_add.dart';
import 'package:flutter_application_1/widgets/timer_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:flutter_application_1/providers/user_state.dart';
import 'package:flutter_application_1/providers/timer_state.dart';

void main() async {
  await initializeDateFormatting();
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
        primarySwatch: Colors.indigo,
      ),
      home: MultiProvider(
        // MultiProvider를 통해 변화에 대해 구독
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => UserState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => TimerState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => FriendState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => RecordState()),
        ],
        child: MyHomePage(),
      ),
    );
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
    FriendState friendState = context.watch<FriendState>();
    TimerState timerState = context.watch<TimerState>();
    RecordState recordState = context.watch<RecordState>();
    return userState.viewModel.getUser() == null
        ? LoginPage()
        : GestureDetector(
            onTap: () {
              print('unfocus');
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                timerState.isAdding = false;
                timerState.editDone();
              });
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
                child: _selectedIndex == 0
                    ? TableEventsExample(
                        // recordState: recordState,
                      )
                    : _widgetOptions.elementAt(_selectedIndex),
              ),
              floatingActionButton: (_selectedIndex == 2 || _selectedIndex == 0)
                  ? FloatingActionButton(
                      onPressed: () {
                        if (_selectedIndex == 0) {
                          recordState.init();
                        } else {
                          friendState.init();
                        }
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
    RecordState recordState = context.watch<RecordState>();
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
                await recordState.init();
              },
              child: const Text('카카오'),
            ),
    );
  }
}
