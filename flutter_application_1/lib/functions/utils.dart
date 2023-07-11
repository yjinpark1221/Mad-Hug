import 'dart:convert';

import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/classes/kakao_login.dart';
import 'package:flutter_application_1/classes/subject.dart';
import 'package:flutter_application_1/functions/toast.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final url = 'http://172.10.5.102:443/api';


Future test () async {
  final response = await http.post(Uri.parse(url), body: {
    'key': 'value',
  });
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future<List<Subject>> getSubjectsList() async {
  if (user == null) throw Exception('no user info');
  print('[REQUEST] get subject');
  // return [];
  var response = await http.get(Uri.parse('$url/subject?uid=${user?.id}&name=${user?.kakaoAccount?.profile?.nickname}'));
  print('response ${response.statusCode}');
  if (response.statusCode == 200) {
    print('[RESPONSE: get subject]');
    print(json.decode(response.body));
    List<dynamic> body = json.decode(response.body) as List<dynamic>;
    List<Subject> allSubject =
        body.map((dynamic item) => Subject.fromJson(item)).toList();
    showToast('과목 정보를 불러왔습니다.');
    return allSubject;
  } else if (response.statusCode <= 201) {
    print('[RESPONSE: get subject]');
    print(json.decode(response.body));
    List<dynamic> body = json.decode(response.body);
    List<Subject> allSubject =
        body.map((dynamic item) => Subject.fromJson(item)).toList();
    showToast('회원가입 완료, 과목 정보를 불러왔습니다.');
    return allSubject;
  } else {
    print('Response status: ${response.statusCode}');
    throw Exception('불러오는데 실패했습니다');
  }
}

Future<List<Group>> getGroupsList() async {
  if (user == null) throw Exception('no user info');

  print('[REQUEST] get group');
  var response = await http.get(Uri.parse('$url/group?uid=${user?.id}'));
    print('[RESPONSE: get group]');
    print(json.decode(response.body));

  if (response.statusCode == 200) {
    print('[RESPONSE: get group]');
    print(json.decode(response.body));
    List<dynamic> body = json.decode(response.body) as List<dynamic>;
    List<Group> allGroup =
        body.map((dynamic item) => Group.fromJson(item)).toList();
    showToast('그룹 정보를 불러왔습니다.');
    return allGroup;
  } else {
    print('Response status: ${response.statusCode}');
    throw Exception('불러오는데 실패했습니다');
  }
}

Future<List<Friend>> getFriendsList() async {
  if (user == null) throw Exception('no user info');

  print('[REQUEST] get friend');
  var response = await http.get(Uri.parse('$url/friend?uid=${user?.id}'));

  if (response.statusCode == 200) {
    print('[RESPONSE: get friend]');
    print(response.body);
    List<dynamic> body = json.decode(response.body) as List<dynamic>;
    List<Friend> allFriend =
        body.map((dynamic item) => Friend.fromJson(item)).toList();

    showToast('친구 정보를 불러왔습니다.');
    return allFriend;
  } else {
    print('Response status: ${response.statusCode}');
    throw Exception('불러오는데 실패했습니다');
  }
}

Future sendEditedSubject(int subjectId, String name) async {
  if (user == null) throw Exception('no user');
  print('[REQUEST] post 과목명 변경 ${user!.id} $subjectId $name');
  final response = await http.post(Uri.parse('$url/subject/edit'), body: {
    'userId': '${user!.id}',
    'subjectId': '$subjectId',
    'subjectName': '$name',
  });
  if (response.statusCode == 200) {
    showToast('과목명 변경이 성공적으로 반영되었습니다. ');
  }
  print('[RESPONSE] post 과목명 변경');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendFriendRequest(int friendId, FriendState friendState) async {
  print('[REQUEST] post 친구 추가');
  final response = await http.post(Uri.parse('$url/friend/add'), body: {
    'userId1': '${user!.id}',
    'userId2': '$friendId',
  });
  if (response.statusCode == 201) {
    showToast('친구 추가가 반영되었습니다. ');
    List<dynamic> body = json.decode(response.body) as List<dynamic>;
    friendState.setFriends(body.map((dynamic item) => Friend.fromJson(item)).toList());
  }
  print('[RESPONSE] post 친구 추가');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendNewSubject(int id, String name) async {
  print('[REQUEST] post 과목 추가');
  final response = await http.post(Uri.parse('$url/subject/add'), body: {
    'userId': '${user!.id}',
    'subjectId': '$id',
    'subjectName': name,
  });
  print('[RESPONSE] post 과목 추가');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendStart(DateTime start, Subject subject) async {
  print('[REQUEST] post 공부 추가');
  final format = DateFormat('yyyy-MM-dd HH:mm:ss');
  final response = await http.post(Uri.parse('$url/record/start'), body: {
    'userId': '${user!.id}',
    'subjectId': '${subject.id}',
    'startTime': '${format.format(start)}',
  });
  print('[RESPONSE] post 공부 추가');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendEnd(DateTime start, DateTime end, Subject subject) async {
  print('[REQUEST] post 공부 추가');
  final format = DateFormat('yyyy-MM-dd HH:mm:ss');

  final response = await http.post(Uri.parse('$url/record/end'), body: {
    'userId': '${user!.id}',
    'subjectId': '${subject.id}',
    'startTime': '${format.format(start)}',
    'endTime': '${format.format(end)}',
  });
  print('[RESPONSE] post 공부 추가');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendGroupRequest(int groupId) async {
  print('[REQUEST] post 그룹 가입');
  final response = await http.post(Uri.parse('$url/group/enter'), body: {
    'userId': '${user!.id}',
    'groupId': '${groupId}',
  });
  print('[RESPONSE] post 그룹 가입');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future sendNewGroup(String name, FriendState friendState) async {
  print('[REQUEST] post 그룹 추가');
  final response = await http.post(Uri.parse('$url/group/add'), body: {
    'userId': '${user!.id}',
    'groupName': '${name}',
  });
  List<dynamic> body = json.decode(response.body) as List<dynamic>;
  List<Group> allGroup =
      body.map((dynamic item) => Group.fromJson(item)).toList();
  friendState.setGroups(allGroup);
  print('[RESPONSE] post 그룹 추가');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}