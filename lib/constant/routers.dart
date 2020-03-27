class CategoryRouters {
  static final addCategory = '/addCategory';
}

class BlogRouters {
  static final add = '/addBlog';
  static final attr = '/attrBlog';
  static final detail = '/detail';
}

class SettingRouters {
  static final setting = '/setting';
  static final file = '/file';
}

class UserRouters {
  static final login = '/login';
}

class SearchRouters {
  static final search = '/search';
  static final searchLabel = '/search/label';
}

class LabelRouters {
  static final labels = '/labels';
}

class LocationRouters {
  static final location = '/locations';
  static final searchLocation = '/search/locations';
}

class AccountRouters {
  static final account = '/account';
}

class PasswordRouters {
  static final password = '/password';
  static final passwordReset = '/password/reset';
}

class LeverRouters {
  static final lever = '/lever';
}

// class OnGenerateRoute {
//   Route<dynamic> Function(RouteSettings settings) {
//      WidgetBuilder builder;
//       if(settings.name != UserRouters.login) {
//         return
//       }else {
// return new MaterialPageRoute(builder: builder, settings: settings);
//       }
//   }
// }
