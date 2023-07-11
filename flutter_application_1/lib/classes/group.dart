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

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      json['groupId'],
      json['groupName'],
      json['members'].map((dynamic item) => Friend.fromJson(item)).toList(),
    );
  }
}

class Friend {
  Friend(this.id, this.name, this.isStudying);
  int id;
  String name;
  bool isStudying;
  String getName() {
    return name;
  }
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      json['userId'],
      json['userName'],
      json['studying'],
    );
  }
}