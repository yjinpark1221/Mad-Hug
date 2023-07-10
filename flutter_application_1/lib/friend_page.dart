import 'package:flutter/material.dart';
import 'package:flutter_application_1/friend_list.dart';
import 'package:flutter_application_1/group.dart';
import 'package:flutter_application_1/group_list.dart';
import 'package:flutter_application_1/toast.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/kakao_login.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({
    super.key,
  });

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late List<Group> groupList;

  Future refreshGroup() async {
    groupList = await getGroupsList();
  }

  @override
  void initState() {
    super.initState();
    refreshGroup();
  }

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
  int? tmp = int.tryParse(groupId);
  if (tmp == null) {
    showToast('그룹 ID를 입력하세요.');
  } else {
    sendGroupRequest(tmp);
  }
}

void makeGroup(String groupName) {
  sendNewGroup(groupName);
}

void addFriend(String friendId) {
  int? tmp = int.tryParse(friendId);
  if (tmp == null) {
    showToast('친구 ID를 입력하세요.');
  } else {
    sendFriendRequest(tmp);
  }
}