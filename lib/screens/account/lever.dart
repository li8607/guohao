import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/lever/lever_bloc.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/tools/toast.dart';
import 'package:guohao/widgets/result.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LeverPage extends StatelessWidget {
  ProgressDialog progressDialog;
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLeverUpdateInProgress) {
          if (progressDialog == null) {
            progressDialog = ProgressDialog(context);
            progressDialog.update(message: '更新会员...');
          }
          progressDialog.show();
        } else if (state is UserLeverUpdateSuccess) {
          ToastUtil.show('更新会员成功');
          progressDialog?.hide();
        } else if (state is UserLeverUpdateFailure) {
          ToastUtil.show('更新会员失败');
          progressDialog?.hide();
        }
      },
      child: BlocBuilder<LeverBloc, LeverState>(
        builder: (context, state) {
          if (state is LeverLoadSuccess) {
            var items = state.levers.map((value) {
              return ListTile(
                  onTap: () async {
                    BlocProvider.of<UserBloc>(context)
                        .add(UserLeverUpdated(lever: value));
                  },
                  title: Text('${value.text}'),
                  subtitle: Text('${value.price}元'));
            }).toList();
            return Scaffold(
              appBar: AppBar(title: Text("升级到高级账户")),
              body: ListView(children: items),
            );
          } else {
            return ResultView();
          }
        },
      ),
    );
  }
}
