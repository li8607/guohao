import 'package:flutter/material.dart';
import 'package:guohao/screens/blog/blog_favorite.dart';
import 'search_word.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.search), border: OutlineInputBorder()),
          ),
        ),
        body: Container(
          color: Colors.redAccent,
        ));
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context)
        .copyWith(textTheme: Theme.of(context).primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchWordPage(
      word: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //如果说已经加载过一次搜索热榜，那么下次就不再重复加载了
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/labels');
          },
          title: Text('标签'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/locations');
          },
          title: Text('地方'),
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
        )
      ],
    );
  }
}
