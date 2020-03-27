import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/result.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController code = TextEditingController();
  TextEditingController newPassword1 = TextEditingController();
  TextEditingController newPassword2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(UserPasswordResetPhoneCodeSended());
  }

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(buildWhen: (psate, cstate) {
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
              controller: code,
              decoration: InputDecoration(hintText: '输入验证码'),
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
                BlocProvider.of<UserBloc>(context).add(
                    UserPasswordFromPhoneReseted(
                        code: code.text,
                        newPassword1: newPassword1.text,
                        newPassword2: newPassword2.text));
              },
              child: Text('确定'),
              color: Theme.of(context).primaryColor,
            )
          ]),
        );
      } else {
        return ResultView();
      }
    }, listener: (context, state) {
      if (state is UserPasswordResetPhoneCodeSendInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在发送验证码...');
        }
        progressDialog.show();
      } else if (state is UserPasswordResetPhoneCodeSendSuccess) {
        ToastUtil.show('验证码发送成功');
        progressDialog?.hide();
        Navigator.of(context).pop();
      } else if (state is UserPasswordResetPhoneCodeSendFailure) {
        ToastUtil.show('验证码发送失败');
        progressDialog?.hide();
      } else if (state is UserPasswordFromPhoneResetInProgress) {
        if (progressDialog == null) {
          progressDialog = ProgressDialog(context);
          progressDialog.update(message: '正在重置密码...');
        }
        progressDialog.show();
      } else if (state is UserPasswordFromPhoneResetSuccess) {
        ToastUtil.show('重置密码成功');
        progressDialog?.hide();
        Navigator.of(context).pop();
      } else if (state is UserPasswordFromPhoneResetFailure) {
        ToastUtil.show('重置密码失败');
        progressDialog?.hide();
      }
    });
  }
}
