import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/user/bloc/user_bloc.dart';
import 'package:guohao/constant/routers.dart';
import 'package:guohao/screens/blog/blog_favorite.dart';
import 'package:guohao/screens/category/category_page.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BlocBuilder<UserBloc, UserState>(
            condition: (pstate, cstate) {
              return cstate is UserLoginInProgress ||
                  cstate is UserLoginSuccess ||
                  cstate is UserLoginFailure;
            },
            builder: (context, state) {
              if (state is UserLoginSuccess) {
                return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage('${state.user.avatar}'),
                    ),
                    accountName: Text(state.user.nickName ?? ""),
                    accountEmail: Text(state.user.email ?? ""));
              } else {
                return UserAccountsDrawerHeader(
                    accountName: Text(""), accountEmail: Text(""));
              }
            },
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/labels');
            },
            title: Text('标签'),
            leading: Icon(Icons.label),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/locations');
            },
            title: Text('地方'),
            leading: Icon(Icons.location_on),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlogFavoritePage(
                  favorite: 1,
                );
              }));
            },
            title: Text('最爱'),
            leading: Icon(Icons.favorite),
          ),
          CategoryPage(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(SettingRouters.setting);
            },
            title: Text('设置'),
            leading: Icon(Icons.settings),
          )
        ],
      )),
    );
  }
}
