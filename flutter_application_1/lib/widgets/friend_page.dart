import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:flutter_application_1/widgets/friend_list.dart';
import 'package:flutter_application_1/widgets/group_list.dart';
import 'package:flutter_application_1/functions/toast.dart';
import 'package:flutter_application_1/functions/utils.dart';
import 'package:flutter_application_1/widgets/popup_add.dart';
import 'package:provider/provider.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({
    super.key,
  });

  @override
  State<FriendPage> createState() => _FriendPageState();
}

FriendState? fs = null;

class _FriendPageState extends State<FriendPage> {
  bool loading = false;

  Future refreshGroup(friendState) async {
    await friendState.init();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fs = context.watch<FriendState>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          loading = true;
          await fs!.init();
          loading = false;
        },
        child: Column(
          children: loading
              ? [CircularProgressIndicator()]
              : [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GroupList(),
                        ),
                        fs?.currentGroup!.id != 0
                            ? PopupDelete(group: fs!.currentGroup!, friendState: fs!)
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FriendList(),
                  )
                ],
        ),
      ),
    );
  }
}

void enterGroup(String groupId) {
  int? tmp = int.tryParse(groupId);
  if (tmp == null) {
    showToast('그룹 ID를 입력하세요.');
  } else {
    sendGroupRequest(tmp, fs!);
  }
}

void makeGroup(String groupName) {
  sendNewGroup(groupName, fs!);
}

void addFriend(String friendId) {
  int? tmp = int.tryParse(friendId);
  if (tmp == null) {
    showToast('친구 ID를 입력하세요.');
  } else {
    sendFriendRequest(tmp, fs!);
  }
}
