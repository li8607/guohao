import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/photo/bloc/photo_bloc.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';
import 'package:guohao/screens/location/location_page.dart';
import 'package:guohao/screens/photo/photo_page.dart';
import 'package:guohao/screens/search/search.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_event.dart';
import 'package:guohao/blocs/category/category_bloc.dart';
import 'package:guohao/blocs/category/category_state.dart';
import 'package:guohao/screens/blog/blog_list.dart';
import 'package:guohao/screens/calendar/calendar.dart';
import 'package:guohao/screens/home/side_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();

  int _currentIndex = 0;

  InfiniteScrollController infiniteController;

  @override
  void initState() {
    super.initState();

    infiniteController = InfiniteScrollController(
      initialScrollOffset: 0.0,
    );
    // WidgetsBinding.instance.addPostFrameCallback((duration) {
    //   final size = MediaQuery.of(context).size;
    //   infiniteController = InfiniteScrollController(
    //     initialScrollOffset: (size.height / 2 - kToolbarHeight - 70),
    //   );
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          String title;
          int categoryId;
          if (state is CategoryLoaded) {
            title = state.currentCategory()?.name;
            categoryId = state.currentCategory()?.id;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(title ?? ''),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchBarDelegate());
                    }),
                Offstage(
                  offstage: false,
                  child: IconButton(
                      icon: Icon(Icons.replay),
                      onPressed: () {
                        infiniteController.animateTo(0.0,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeIn);
                      }),
                )
              ],
            ),
            drawer: SideDrawer(),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                BlogListPage(
                  key: ValueKey(categoryId ?? -1),
                ),
                PhotoPage(),
                LocationPage(),
                CalendarPage(
                  controller: infiniteController,
                )
              ],
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            bottomNavigationBar: BottomAppBar(
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                              SizedBox(height: 49, child: bottomAppBarItem(0))),
                      Expanded(
                          flex: 1,
                          child:
                              SizedBox(height: 49, child: bottomAppBarItem(1))),
                      Expanded(flex: 1, child: SizedBox(height: 49)),
                      Expanded(
                          flex: 1,
                          child:
                              SizedBox(height: 49, child: bottomAppBarItem(2))),
                      Expanded(
                          flex: 1,
                          child:
                              SizedBox(height: 49, child: bottomAppBarItem(3))),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  )),
              shape: CircularNotchedRectangle(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                BlocProvider.of<BlogsBloc>(context).add(BlogInserted());
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }

  List<BottomItem> bottoms = [
    BottomItem(name: '首页', icon: Icons.menu),
    BottomItem(name: '图库', icon: Icons.image),
    BottomItem(name: '位置', icon: Icons.location_on),
    BottomItem(name: '日历', icon: Icons.calendar_today)
  ];

  Widget bottomAppBarItem(int index) {
    Widget item = Container(
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(bottoms[index].icon,
                size: 25,
                color: _currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.black45),
            Text(
              bottoms[index].name,
              style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: _currentIndex == index ? 13 : 12,
                  color: _currentIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.black45),
            )
          ],
        ),
        onTap: () {
          pageController.jumpToPage(index);
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
    return item;
  }
}

class BottomItem {
  final String name;
  final IconData icon;

  BottomItem({this.name, this.icon});
}
