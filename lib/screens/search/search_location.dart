import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/blocs/location/bloc/location_bloc.dart';
import 'package:guohao/repositorys/location/location_entity.dart';
import 'package:guohao/widgets/result.dart';

import 'search_result.dart';

class SearchLocation extends StatefulWidget {
  final LocationEntity location;

  SearchLocation({Key key, this.location}) : super(key: key);

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationBloc>(context).add(LocationLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.location.name ?? ''),
          ),
          body: SearchResult(
              blogs: state.getBlogsByLocation(widget?.location?.id)),
        );
      } else {
        return ResultView();
      }
    });
  }
}
