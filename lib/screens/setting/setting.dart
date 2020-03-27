import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:share/share.dart';
import 'package:guohao/blocs/home/home_bloc.dart';
import 'package:guohao/blocs/home/home_event.dart';
import 'package:guohao/blocs/home/home_state.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/constant/routers.dart';
import 'package:guohao/tools/dialog.dart';
import 'package:guohao/tools/toast.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
        ),
        body: ListView(children: [
          BlocBuilder<UserBloc, UserState>(condition: (pstate, cstate) {
            return cstate is UserLoginInProgress ||
                cstate is UserLoginSuccess ||
                cstate is UserLoginFailure;
          }, builder: (context, state) {
            var avatar;
            if (state is UserLoginSuccess) {
              avatar = state.user.avatar;
            }
            return ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/account');
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage('$avatar'),
              ),
              title: Text('账号'),
              subtitle: Text('签到'),
            );
          }),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/lever');
            },
            leading: Icon(Icons.account_box),
            title: Text("账号状态"),
            subtitle: Text('基本'),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text('同步'),
            subtitle: Text('无'),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("分类"),
            subtitle: Text('4'),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('样式'),
            subtitle: Text("字体 39"),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('高级'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('提醒和通知'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('密码'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('智能管家'),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('导入/导出'),
            onTap: () async {
              showExportDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('支持'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('关于'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('查看欢迎屏幕'),
          ),
        ]),
      );
    }, listener: (context, state) {
      if (state is ExportAppSuccess) {
        Navigator.of(context).pop();
        showExportResultDialog(context, state.path);
      } else if (state is ImportAppSuccess) {
        Navigator.of(context).pop();
        ToastUtil.show('导入成功');
      } else if (state is ExportAppFailure) {
        Navigator.of(context).pop();
        ToastUtil.show('导出失败');
      } else if (state is ImportAppFailure) {
        Navigator.of(context).pop();
        ToastUtil.show('导入失败');
      } else if (state is ExportAppInProgress) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LoadingDialog(text: '正在导出...'));
      } else if (state is ImportAppInProgress) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LoadingDialog(text: '正在导入...'));
      }
    });
  }

  void showExportResultDialog(BuildContext context, String path) {
    showDialog(
        barrierDismissible: false,
        context: context,
        child: SimpleDialog(
          title: Text('导出'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                ToastUtil.show('保存成功,$path');
                Navigator.of(context).pop();
              },
              child: ListTile(title: Text('保存到设备')),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Share.shareFile(File(path));
              },
              child: ListTile(title: Text('分享')),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      File(path).delete();
                      Navigator.of(context).pop();
                    },
                    child: Text('取消'))
              ],
            )
          ],
        ));
  }

  void showExportDialog(BuildContext context) async {
    int result = await showDialog(
        context: context,
        child: SimpleDialog(
          title: Text('导入/导出'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop(1);
              },
              child: ListTile(title: Text('导入JSON')),
            ),
            SimpleDialogOption(
              onPressed: () {
                HomeBloc homeBloc = BlocProvider.of(context);
                homeBloc.add(AppExported());
                Navigator.of(context).pop(2);
              },
              child: ListTile(title: Text('导出JSON')),
            ),
            SimpleDialogOption(
              onPressed: () {},
              child: ListTile(title: Text('导出PDF')),
            )
          ],
        ));

    if (result == 1) {
      Navigator.of(context).pushNamed(SettingRouters.file).then((value) {
        if (value != null) {
          HomeBloc homeBloc = BlocProvider.of(context);
          homeBloc.add(AppImported(value.toString()));
        }
      });
    }
  }
}
