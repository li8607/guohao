import 'package:leancloud_storage/leancloud.dart';

class User {
  final String username;
  final String nickName;
  final String id;
  final String email;
  final String sign;
  final String avatar;

  User(
      {this.id,
      this.username,
      this.nickName,
      this.email,
      this.sign,
      this.avatar});

  static User fromLcUser(LCUser lcUser) {
    return User(
        id: lcUser.objectId,
        username: lcUser.username,
        nickName: lcUser['nickname'],
        sign: lcUser['sign'],
        avatar: lcUser['avatar'],
        email: lcUser.email);
  }
}
