import 'dart:io';

import 'package:leancloud_storage/leancloud.dart';
import 'package:guohao/repositorys/user/user.dart';
import 'package:tobias/tobias.dart';

class UserRepository {
  static final UserRepository _locationRepository = UserRepository._internal();

  UserRepository._internal();

  static UserRepository get() {
    return _locationRepository;
  }

  login(String username, String password) async {
    LCUser lcUser = await LCUser.login(username, password);
    return User.fromLcUser(lcUser);
  }

  loginMe() async {
    LCUser lcUser = await LCUser.getCurrent();
    lcUser = await LCUser.becomeWithSessionToken(lcUser.sessionToken);
    return User.fromLcUser(lcUser);
  }

  register(String username, String password, String email) async {
    LCUser lcUser = LCUser();
    lcUser.username = username;
    lcUser.password = password;
    lcUser.email = email;
    lcUser = await lcUser.signUp();
    return User.fromLcUser(lcUser);
  }

  updateNickname(String nickname) async {
    LCUser lcUser = await LCUser.getCurrent();
    lcUser["nickname"] = nickname;
    lcUser.save();
    return User.fromLcUser(lcUser);
  }

  updateSign(String sign) async {
    LCUser lcUser = await LCUser.getCurrent();
    lcUser["sign"] = sign;
    lcUser.save();
    return User.fromLcUser(lcUser);
  }

  resetPasswordFromEmail(String oldPassword, String newPassword) async {
    LCUser lcUser = await LCUser.getCurrent();
    await lcUser.updatePassword(oldPassword, newPassword);
    return login(lcUser.username, newPassword);
  }

  passwordResetFromEmail() async {
    LCUser lcUser = await LCUser.getCurrent();
    return LCUser.requestPasswordReset(lcUser.email);
  }

  sendPhoneCode() async {
    LCUser lcUser = await LCUser.getCurrent();
    return LCUser.requestPasswordRestBySmsCode(lcUser.mobile);
  }

  passwordResetFromPhone(String code, String newPassword) async {
    LCUser lcUser = await LCUser.getCurrent();
    return LCUser.resetPasswordBySmsCode(lcUser.mobile, code, newPassword);
  }

  logout() async {
    return LCUser.logout();
  }

  updateAvatar(File avatar) async {
    LCUser lcUser = await LCUser.getCurrent();
    LCFile lcFile = await LCFile.fromPath(
        DateTime.now().microsecondsSinceEpoch.toString(), avatar.path);
    lcFile = await lcFile.save();
    lcUser['avatar'] = lcFile.url;
    await lcUser.save();
    return User.fromLcUser(lcUser);
  }

  updateLever(String leverId) async {
    print('leverId $leverId');
    var result = await LCCloud.run('order', params: {"lever": leverId});
    Map payResult = await aliPay(result['result'], evn: AliPayEvn.SANDBOX);
    if (payResult != null && payResult['code'] == 9000) {
      return loginMe();
    }
  }
}
