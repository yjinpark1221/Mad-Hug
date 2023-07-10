import 'package:flutter_application_1/group.dart';
import 'package:flutter_application_1/subject.dart';
import 'package:http/http.dart' as http;

List<Subject> getSubjectListFromServer() {
  // TODO : 서버로부터 정보 받아서 List로 만들기
  print('[SERVER->] getting subject list');
  return [Subject('국어'), Subject('수학')];
}

Future test () async {
  final url = Uri.parse('http://172.10.5.102:80');
  final response = await http.post(url, body: {
    'key': 'value',
  });
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

}
void sendRecordToServer(DateTime start, DateTime end, Subject subject) {
  // TODO : 사용자 정보랑 같이 보내기
  print('[SERVER<-] $start ~ $end ( ${subject.id} )');
}

void sendSubjectNameToServer(String name, int id) {
  // TODO : id에 해당하는 subject를 바꿨음을 알리기
  print('[SERVER<-] 변경된 과목 $name ($id) ');
}

int subjectid = 10;

int sendNewSubjectToServer(String name, int id) {
  // TODO : id에 해당하는 subject를 생겼음을 알리기

  print('[SERVER<-] 추가된 과목 $name ($id) ');
  return subjectid++;
}

List<Group> getGroupListFromServer() {
  return [Group(1, '그룹1', [Friend(55, '연진', false)]), Group(2, '그룹2', [Friend(55, '연진', false), Friend(56, '정민', true)]), Group(3, '그룹3', []), Group(4, '그룹4', []), Group(6, '그룹5', []), Group(6, '그룹6', [])];
}

List<Friend> getFriendListFromServer() {
  return [Friend(33, '친구1', true), Friend(34, '친구2', true), Friend(35, '친구3', false)];
}

void updateFriendsState() {

}

void sendGroupRegisteration(int groupId) {
  print('[SERVER<-] 그룹 가입');
}

void sendNewGroup(String groupName) {
  print('[SERVER<-] 그룹 생성');
}

void sendFriendRequest(int friendId) {
  print('[SERVER<-] 친구 추가');
}