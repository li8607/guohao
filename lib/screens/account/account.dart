import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/result.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AccountPage extends StatelessWidget {
  var progressDialog;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is UserNicknameUpdateInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在更新昵称...');
        }
        progressDialog.show();
      } else if (state is UserNicknameUpdateSuccess) {
        ToastUtil.show('更新昵称成功');
        progressDialog?.hide();
      } else if (state is UserNicknameUpdateFailure) {
        ToastUtil.show('更新昵称失败');
        progressDialog?.hide();
      } else if (state is UserSignUpdateInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在更新个性签名...');
        }
        progressDialog.show();
      } else if (state is UserSignUpdateSuccess) {
        ToastUtil.show('更新个性签名成功');
        progressDialog?.hide();
      } else if (state is UserSignUpdateFailure) {
        ToastUtil.show('更新个性签名失败');
        progressDialog?.hide();
      } else if (state is UserPasswordFromEmailResetInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在发送重置密码邮件...');
        }
        progressDialog.show();
      } else if (state is UserPasswordFromEmailResetSuccess) {
        ToastUtil.show('重置密码邮件发送成功');
        progressDialog?.hide();
      } else if (state is UserPasswordFromEmailResetFailure) {
        ToastUtil.show('重置密码邮件发送失败');
        progressDialog?.hide();
      } else if (state is UserLogoutInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在注销...');
        }
        progressDialog.show();
      } else if (state is UserLogoutSuccess) {
        ToastUtil.show('注销成功');
        progressDialog?.hide();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', ModalRoute.withName('/'));
      } else if (state is UserLogoutFailure) {
        ToastUtil.show('注销失败');
        progressDialog?.hide();
      } else if (state is UserAvatarUpdateInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '更新头像...');
        }
        progressDialog.show();
      } else if (state is UserAvatarUpdateSuccess) {
        ToastUtil.show('更新头像成功');
        progressDialog?.hide();
      } else if (state is UserAvatarUpdateFailure) {
        ToastUtil.show('更新头像失败');
        progressDialog?.hide();
      }
    }, buildWhen: (pstate, cstate) {
      return cstate is UserLoginSuccess ||
          cstate is UserLoginFailure ||
          cstate is UserLoginInProgress;
    }, builder: (context, state) {
      if (state is UserLoginSuccess) {
        return Scaffold(
          appBar: AppBar(
            title: Text('账户安全'),
          ),
          body: ListView(children: [
            ListTile(
              onTap: () {
                _updateAvatar(context);
              },
              title: Text('头像'),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage('${state.user.avatar}'),
              ),
            ),
            ListTile(
              onTap: () {
                _updateNickname(context, state.user.nickName);
              },
              title: Text('昵称'),
              trailing: state.user.nickName == null
                  ? null
                  : Text('${state.user.nickName}'),
            ),
            ListTile(
              onTap: () {
                _updateSign(context, state.user.sign);
              },
              title: Text('个性签名'),
              trailing:
                  state.user.sign == null ? null : Text('${state.user.sign}'),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ListTile(
                title: Text('修改邮箱'),
                trailing: Text('${state.user.email ?? ""}')),
            ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('/password');
                },
                title: Text('修改密码'),
                trailing: Icon(Icons.arrow_right)),
            PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    BlocProvider.of<UserBloc>(context)
                        .add(UserPasswordFromEmailReseted());
                  } else if (value == 2) {
                    Navigator.of(context).pushNamed('/password/reset');
                  }
                },
                child: ListTile(
                    title: Text('忘记密码'), trailing: Icon(Icons.arrow_right)),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(enabled: false, child: Text("忘记密码")),
                    PopupMenuItem(value: 1, child: Text("邮箱")),
                    PopupMenuItem(value: 2, child: Text("手机号")),
                  ];
                }),
            ListTile(
                onTap: () {
                  BlocProvider.of<UserBloc>(context).add(UserLogouted());
                },
                title: Text('注销账号'),
                trailing: Icon(Icons.arrow_right)),
          ]),
        );
      } else {
        return ResultView();
      }
    });
  }

  _updateAvatar(BuildContext context) async {
    var result = await showModalBottomSheet<int>(
        context: context,
        builder: (context) {
          return ListView(shrinkWrap: true, children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(2);
                },
                child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text('拍照'))),
            Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).pop(1);
                },
                child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text('相片库'))),
            Divider(
              height: 8,
              thickness: 8,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text('取消'))),
          ]);
        });
    File image;
    if (result == 1) {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else if (result == 2) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      BlocProvider.of<UserBloc>(context)
          .add(UserAvatarUpdated(avatar: croppedFile));
    }
  }

  _updateSign(BuildContext context, String sign) async {
    var controller = TextEditingController(text: sign ?? "");
    var result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改个性签名'),
        content: TextField(
          autofocus: true,
          controller: controller,
        ),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('取消')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('确定'))
            ],
          )
        ],
      ),
    );
    if (result != null && result) {
      BlocProvider.of<UserBloc>(context)
          .add(UserSignUpdated(sign: controller.text));
    }
  }

  _updateNickname(BuildContext context, String nickname) async {
    var controller = TextEditingController(text: nickname ?? "");
    var result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改昵称'),
        content: TextField(
          autofocus: true,
          controller: controller,
        ),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('取消')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('确定'))
            ],
          )
        ],
      ),
    );
    if (result != null && result) {
      BlocProvider.of<UserBloc>(context)
          .add(UserNicknameUpdated(nickname: controller.text));
    }
  }
}
