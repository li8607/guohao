import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/location/bloc/location_bloc.dart';
import 'package:guohao/repositorys/location/location_entity.dart';
import 'package:guohao/screens/search/search_location.dart';
import 'package:guohao/widgets/result.dart';

class LocationListPage extends StatefulWidget {
  LocationListPage({Key key}) : super(key: key);

  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationBloc>(context).add(LocationLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
      if (state is LocationSuccess) {
        List<LocationEntity> locations = state.locations;
        print('dddd  $locations');
        return Scaffold(
          appBar: AppBar(
            title: Text('地方'),
          ),
          body: Container(
              child: ListView.builder(
                  itemCount: locations?.length ?? 0,
                  itemBuilder: (context, index) {
                    LocationEntity locaiton = locations[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SearchLocation(
                            location: locaiton,
                          );
                        }));
                      },
                      leading: Icon(Icons.location_on),
                      title: Text(locaiton.name ?? ''),
                    );
                  })),
        );
      } else {
        return ResultView();
      }
    });
  }
}
