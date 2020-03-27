import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/result.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PasswordUpdatePage extends StatefulWidget {
  @override
  _PasswordUpdatePagePageState createState() => _PasswordUpdatePagePageState();
}

class _PasswordUpdatePagePageState extends State<PasswordUpdatePage> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword1 = TextEditingController();
  TextEditingController newPassword2 = TextEditingController();
  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is UserPasswordUpdateInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在更新密码...');
        }
        progressDialog.show();
      } else if (state is UserPasswordUpdateSuccess) {
        ToastUtil.show('更新密码成功');
        progressDialog?.hide();
        Navigator.of(context).pop();
      } else if (state is UserPasswordUpdateFailure) {
        ToastUtil.show('更新密码失败');
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
            title: Text('修改密码'),
          ),
          body: ListView(padding: const EdgeInsets.all(20), children: [
            TextField(
              obscureText: true,
              controller: oldPassword,
              decoration: InputDecoration(hintText: '输入旧密码'),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              controller: newPassword1,
              decoration: InputDecoration(hintText: '输入新密码'),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              controller: newPassword2,
              decoration: InputDecoration(hintText: '输入新密码'),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                BlocProvider.of<UserBloc>(context).add(UserPasswordUpdated(
                    oldPassword: oldPassword.text,
                    newPassword1: newPassword1.text,
                    newPassword2: newPassword2.text));
              },
              child: Text('提交'),
              color: Theme.of(context).primaryColor,
            )
          ]),
        );
      } else {
        return ResultView();
      }
    });
  }
}
