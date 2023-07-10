import 'package:flutter/material.dart';
import 'package:flutter_application_1/friend_list.dart';
import 'package:flutter_application_1/group.dart';
import 'package:flutter_application_1/group_list.dart';
import 'package:flutter_application_1/utils.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({
    super.key,
  });

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Group> groupList = getGroupListFromServer();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupList(),
        Expanded(
          child: FriendList(),
        )
      ],
    );
  }
}

void enterGroup(String groupId) {
  sendGroupRegisteration(int.parse(groupId));
}

void makeGroup(String groupName) {
  sendNewGroup(groupName);
}

void addFriend(String friendId) {
  sendFriendRequest(int.parse(friendId));
}