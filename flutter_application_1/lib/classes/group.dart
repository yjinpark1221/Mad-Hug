import 'dart:convert';

class Group {
  static int cnt = 0;
  int id = ++cnt;
  List<Friend> members;
  Group(this.id, this._name, this.members);
  String _name;
  void setName(String name) {
    _name = name;
  }
  String getName() {
    return _name;
  }

  factory Group.fromJson(Map<String, dynamic> g) {
    print(g['members'].toString());
    List<dynamic> members = json.decode(g['members'].toString()) as List<dynamic>;
      return Group(
      g['groupId'],
      g['groupName'],
      members.map((dynamic item) => Friend.fromJson(item)).toList(),
    );
  }
}

enum Mood { none, happy, sad, tired, angry, confused, excited }

class Friend {
  Friend(this.id, this.name, this.isStudying, this.mood);
  int id;
  String name;
  Mood mood;
  bool isStudying;
  String getName() {
    return name;
  }
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      json['userId'],
      json['userName'],
      json['studying'],
      Mood.values[json['mood']],
    );
  }
}