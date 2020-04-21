class User {
  int _id;
  String _username;
  int _time;
  String _format;

  User(this._id, this._username, this._time, this._format) ;

  User.map(dynamic obj) {
    this._id = obj['id'];
    this._username = obj['username'];
    this._time = obj['time'];
    this._format = obj['format'];
  }

  int get id => _id;
  String get username => _username;
  int get score => _time;
  String get format => _format;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["username"] = _username;
    map["time"] = _time;
    map["format"] = _format;
    return map;
  }
}