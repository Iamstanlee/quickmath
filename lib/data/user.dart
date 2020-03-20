// enum Rank {}
class User {
  String username, phonenumber, avatar, uid, email, rank;
  bool online, isGameCreator;
  int rankXp;
  User(
      {this.username,
      this.online,
      this.email,
      this.rank,
      this.rankXp,
      this.isGameCreator,
      this.phonenumber,
      this.avatar,
      this.uid});
  User.fromMap(Map map) {
    this.username = map['username'];
    this.phonenumber = map['phone'];
    this.uid = map['userId'];
    this.isGameCreator = map['isGameCreator'];
    this.online = map['online'];
    this.avatar = map['avatar'];
    this.email = map['email'];
    this.rank = map['rank'];
    this.rankXp = map['rankXp'];
  }
  static Map<String, dynamic> toMap(User user) {
    return {
      'username': user.username,
      'phone': user.phonenumber,
      'userId': user.uid,
      'isGameCreator': user.isGameCreator,
      'online': user.online,
      'avatar': user.avatar,
      'rank': user.rank,
      'rankXp': user.rankXp,
      'email': user.email
    };
  }
}
