import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guohao/repositorys/photo/photo_repository.dart';
import 'package:zefyr/zefyr.dart';

class AppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final PhotoRepository photoRepository = PhotoRepository.get();

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    String id = await photoRepository.insertOrReplace(file);
    return id;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    return ZefyrImage(
      key: ValueKey(key),
      id: key,
    );
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}

class ZefyrImage extends StatefulWidget {
  final String id;

  const ZefyrImage({Key key, this.id}) : super(key: key);

  @override
  _ZefyrImageState createState() => _ZefyrImageState();
}

class _ZefyrImageState extends State<ZefyrImage> {
  final PhotoRepository photoRepository = PhotoRepository.get();
  String _id;
  Uint8List photo;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    loadPhoto();
  }

  @override
  Widget build(BuildContext context) {
    if (photo == null) {
      return SizedBox();
    }
    final image = MemoryImage(photo);
    return Container(
        width: double.infinity,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: image,
              fit: BoxFit.cover,
            )));
  }

  void loadPhoto() async {
    photo = await photoRepository.getPhotoFromIdentifier(_id);
    setState(() {});
  }
}
