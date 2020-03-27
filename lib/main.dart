import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/location/bloc/location_bloc.dart';
import 'package:guohao/repositorys/blog_label/blog_label_repositorys.dart';
import 'package:guohao/repositorys/label/label_repository.dart';
import 'package:guohao/repositorys/location/location_repository.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';
import 'package:guohao/screens/account/lever.dart';
import 'package:guohao/screens/account/password_update.dart';
import 'package:guohao/screens/blog/blog_detail.dart';
import 'package:guohao/screens/label/label.dart';
import 'package:guohao/screens/location/location_list.dart';
import 'package:guohao/screens/search/search.dart';
import 'package:guohao/screens/search/search_location.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:guohao/blocs/home/home_bloc.dart';
import 'package:guohao/repositorys/blog/blog_repository.dart';
import 'package:guohao/repositorys/user/user_repository.dart';
import 'package:guohao/screens/blog/add_blog.dart';
import 'package:guohao/screens/blog/blog_attr.dart';
import 'package:guohao/screens/category/add_category_page.dart';
import 'package:guohao/screens/login/welcomePage.dart';
import 'package:guohao/screens/setting/setting.dart';
import 'blocs/blogs/blogs_bloc.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/home/home_event.dart';
import 'blocs/label/label_bloc.dart';
import 'blocs/lever/lever_bloc.dart';
import 'blocs/simple_bloc_delegate.dart';
import 'blocs/user/bloc/user_bloc.dart';
import 'constant/routers.dart';
import 'repositorys/app_repository.dart';
import 'repositorys/category/category_repository.dart';
import 'repositorys/lever/lever_repository.dart';
import 'screens/account/account.dart';
import 'screens/account/password_reset.dart';
import 'screens/home/home.dart';
import 'screens/splash/AnimatedSplashScreen.dart';
import 'package:guohao/styles/styles.dart' as app_styles;

void main() async {
  LeanCloud.initialize(
      'lvxbRe1kWr1j27axXcQyU3fO-gzGzoHsz', 'TUushuU4Bt5rdpuA4DvXbWSl',
      server: 'https://lc.dfmm.fun');
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CategoryBloc categoryBloc;
  BlogsBloc blogsBloc;
  HomeBloc homeBloc;
  UserBloc userBloc;
  LabelBloc labelBloc;
  LocationBloc locationBloc;
  @override
  void initState() {
    super.initState();
    userBloc = UserBloc(userRepository: UserRepository.get());
    homeBloc = HomeBloc(appRepository: AppRepository.get());
    labelBloc =
        LabelBloc(labelRepository: LabelRepository.get(), homeBloc: homeBloc);
    categoryBloc = CategoryBloc(
        homeBloc: homeBloc, categoryRepository: CategoryRepository.get());
    locationBloc = LocationBloc(locationRepository: LocationRepository.get());

    blogsBloc = BlogsBloc(
        categoryBloc: categoryBloc,
        labelBloc: labelBloc,
        locationBloc: locationBloc,
        blogRepository: BlogRepository.get(),
        blogLabelRepository: BlogLabelRepository.get(),
        photoRepository: PhotoRepository.get(),
        locationRepository: LocationRepository.get());
    homeBloc.add(AppStarted());
    locationBloc.add(Locationed());
  }

  @override
  void dispose() {
    super.dispose();
    userBloc?.close();
    homeBloc?.close();
    labelBloc?.close();
    categoryBloc?.close();
    blogsBloc?.close();
    locationBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(providers: [
    //   BlocProvider<UserBloc>(
    //     create: (BuildContext context) => userBloc,
    //   ),
    //   BlocProvider<HomeBloc>(
    //     create: (BuildContext context) => homeBloc,
    //   ),
    //   BlocProvider<LabelBloc>(
    //     create: (BuildContext context) => labelBloc,
    //   ),
    //   BlocProvider<CategoryBloc>(
    //     create: (BuildContext context) => categoryBloc,
    //   ),
    //   BlocProvider<BlogsBloc>(
    //     create: (BuildContext context) => blogsBloc,
    //   ),
    //   BlocProvider<LocationBloc>(
    //     create: (BuildContext context) => locationBloc..add(Locationed()),
    //   ),
    // ], child: MyMaterialApp());

    return BlocProvider.value(
        value: userBloc,
        child: BlocProvider.value(
            value: homeBloc,
            child: BlocProvider.value(
                value: labelBloc,
                child: BlocProvider.value(
                    value: categoryBloc,
                    child: BlocProvider.value(
                        value: blogsBloc,
                        child: BlocProvider.value(
                            value: locationBloc, child: MyMaterialApp()))))));
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light().copyWith(),
      title: '二飞日记',
      home: AnimatedSplashScreen(),
      // onGenerateRoute: ,
      theme: ThemeData(
          scaffoldBackgroundColor: app_styles.kScaffoldBackgroundColor,
          primarySwatch: app_styles.kPrimarySwatch,
          accentColor: app_styles.kAccentColor),
      routes: {
        '/home': (context) {
          return HomePage();
        },
        CategoryRouters.addCategory: (context) {
          return AddCategoryPage();
        },
        BlogRouters.add: (context) {
          return AddBlogPage();
        },
        BlogRouters.attr: (context) {
          return BlogAttrPage();
        },
        BlogRouters.detail: (context) {
          return BlogDetailPage();
        },
        SettingRouters.setting: (context) {
          return SettingPage();
        },
        UserRouters.login: (context) {
          return WelcomePage();
        },
        SearchRouters.search: (context) {
          return SearchPage();
        },
        LabelRouters.labels: (context) {
          return LabelPage();
        },
        LocationRouters.location: (context) {
          return LocationListPage();
        },
        LocationRouters.searchLocation: (context) {
          return SearchLocation();
        },
        AccountRouters.account: (context) {
          return AccountPage();
        },
        PasswordRouters.password: (context) {
          return PasswordUpdatePage();
        },
        PasswordRouters.passwordReset: (context) {
          return PasswordResetPage();
        },
        LeverRouters.lever: (context) {
          return BlocProvider(
              create: (context) =>
                  LeverBloc(leverRepository: LeverRepository.get())
                    ..add(LeverLoaded()),
              child: LeverPage());
        }
      },
    );
  }
}
