import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/group.dart';
import 'package:flutter_application_1/providers/friend_state.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendList createState() => _FriendList();
}

class _FriendList extends State<FriendList> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _textFocusNode = FocusNode(); // 포커스 노드 추가

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textFocusNode.dispose(); // 포커스 노드 해제
  }

  Group getGroup(FriendState friendState) {
    if (friendState.getGroup() == null) {
      friendState.setGroup(0);
    }
    return friendState.currentGroup!;
  }

  @override
  Widget build(BuildContext context) {
    FriendState friendState = context.watch<FriendState>();

    return Container(
      height: 100,
      child: GridView.builder(
        itemCount: getGroup(friendState).members.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
          childAspectRatio: 1 / 1.3, //item 의 가로 1, 세로 2 의 비율
          mainAxisSpacing: 10, //수평 Padding
          crossAxisSpacing: 10, //수직 Padding
        ),
        itemBuilder: (context, index) {
          Friend friend = friendState.currentGroup!.members[index];
          return FriendTile(
            friendState: friendState,
            friend: friend,
          );
        },
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  const FriendTile({
    super.key,
    required this.friendState,
    required this.friend,
  });

  final FriendState? friendState;
  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListTile(
        contentPadding: EdgeInsets.zero, // contentPadding 제거
        title: Container(
          width: double.infinity, // 버튼이 ListTile의 가로 공간을 가득 채울 수 있도록 설정
          height: double.infinity,
          child: Column(
            children: [
              Icon(
                friend.isStudying ? Icons.local_fire_department : Icons.coffee,
                size: 80,
                color: friend.isStudying
                    ? Color.fromARGB(255, 250, 117, 99)
                    : Color.fromARGB(255, 151, 118, 99),
                shadows: <Shadow>[
                  Shadow(color: const Color.fromARGB(100, 112, 112, 112), blurRadius: 15.0)
                ],
              ),
              ElevatedButton(
                onPressed: friend.isStudying ? () {} : null,
                child: Text(
                  '${friend.getName()} ${friend.isStudying ? ' 몰입 중' : ' 휴식 중'}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
