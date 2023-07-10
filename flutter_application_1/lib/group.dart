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
}

class Friend {
  Friend(this.id, this.name, this.isStudying);
  int id;
  String name;
  bool isStudying;
  String getName() {
    return name;
  }
}