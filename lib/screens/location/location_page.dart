import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:guohao/blocs/blogs/blogs_bloc.dart';
import 'package:guohao/blocs/blogs/blogs_state.dart';
import 'package:guohao/blocs/location/bloc/location_bloc.dart';
import 'package:guohao/repositorys/blog/blog_entity.dart';
import 'package:guohao/repositorys/location/location_entity.dart';
import 'package:guohao/screens/blog/add_blog.dart';
import 'package:guohao/tools/notus_document_util.dart';
import 'package:guohao/widgets/result.dart';
import 'package:latlong/latlong.dart';

class LocationPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsBloc, BlogsState>(condition: (pstate, cstate) {
      return cstate is BlogsLoadInProgress ||
          cstate is BlogsLoadSuccess ||
          cstate is BlogsLoadFailure;
    }, builder: (context, state) {
      if (state is BlogsLoadSuccess) {
        Map<LocationEntity, List<BlogEntity>> locationMap = {};
        state.getBlogsHasLocation()?.forEach((blog) {
          if (locationMap.containsKey(blog.location)) {
            locationMap[blog.location].add(blog);
          } else {
            locationMap[blog.location] = [blog];
          }
        });
        var location = BlocProvider.of<LocationBloc>(context).getLocation();

        return Container(
            child: MapPage(
          locations: locationMap,
          latitude: location?.latitude,
          longitude: location?.longitude,
        ));
      } else {
        return ResultView();
      }
    });
  }
}

class MapPage extends StatefulWidget {
  final Map<LocationEntity, List<BlogEntity>> locations;
  final List<LatLng> points;
  final double latitude;
  final double longitude;

  const MapPage(
      {Key key, this.locations, this.points, this.latitude, this.longitude})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers;
  LatLng latLng;
  @override
  void initState() {
    markers = [];
    widget.locations.keys.forEach((location) {
      markers.add(Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 60,
        width: 30,
        point: LatLng(location.latitude, location.longitude),
        builder: (ctx) {
          return PopupMenuButton(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset('assets/images/map_blog.png'),
              Text(
                location.name,
                overflow: TextOverflow.ellipsis,
              )
            ]),
            onSelected: (value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddBlogPage(blogId: value);
              }));
            },
            itemBuilder: (context) {
              var items =
                  widget.locations[location].map<PopupMenuItem>((value) {
                return PopupMenuItem<int>(
                  value: value.id,
                  child: Text('${NotusDocumentUtil.getTitle(value.title)}'),
                );
              }).toList();
              items.insert(
                  0,
                  PopupMenuItem<int>(
                    enabled: false,
                    child: Text(
                      '${location.name}',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 20),
                    ),
                  ));
              return items;
            },
          );
        },
      ));
    });

    latLng = LatLng(widget.latitude ?? 39, widget.longitude ?? 116);

    super.initState();
  }

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: latLng,
          zoom: 5,
          maxZoom: 12,
          minZoom: 5,
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'http://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
            subdomains: ['1', '2', '3', '4'],

            // urlTemplate: 'http://mt{s}.google.cn/vt/lyrs=m&x={x}&y={y}&z={z}',
            // subdomains: ['0', '1', '2', '3'],
            // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            // subdomains: ['a', 'b', 'c'],
          ),
          // new MarkerLayerOptions(
          //   markers: markers,
          // ),

          MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: Size(40, 40),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: markers,
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            builder: (context, markers) {
              return FloatingActionButton(
                heroTag: markers,
                child: Text(markers.length.toString()),
                onPressed: null,
              );
            },
          ),

          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 20.0,
                height: 20.0,
                point: latLng,
                builder: (ctx) => new Container(
                  child: Icon(
                    Icons.location_on,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
