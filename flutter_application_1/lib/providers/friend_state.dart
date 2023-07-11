
import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/functions/utils.dart';

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

  void setFriends(List<Friend> fl) {
    print('친구 초기화중');
    friends.members = fl;
    currentGroup = friends;
    notifyListeners();
  }
  
  void setGroups(List<Group> fl) {
    print('친구 초기화중');
    groups = fl;
    currentGroup = fl.last;
    notifyListeners();
  }
  
  Future init() async {
    if (currentGroup == null) {
      currentGroup = friends;
    }
    friends = Group(0, '친구', await getFriendsList());
    groups = await getGroupsList();
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
