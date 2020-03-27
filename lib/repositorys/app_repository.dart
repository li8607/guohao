import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:guohao/repositorys/blog/blog_repository.dart';
import 'package:guohao/repositorys/category/category_entity.dart';
import 'package:guohao/repositorys/category/category_repository.dart';
import 'package:archive/archive_io.dart';

import 'blog/blog_entity.dart';

class AppRepository {
  final BlogRepository blogRepository;
  final CategoryRepository categoryRepository;

  AppRepository._internal(this.blogRepository, this.categoryRepository);

  static final AppRepository _appRepository =
      AppRepository._internal(BlogRepository.get(), CategoryRepository.get());

  static AppRepository get() {
    return _appRepository;
  }

  export() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      return null;
    }

    final _path = await getApplicationDocumentsDirectory();
    String path = _path.path;
    File blog = File('$path/blog.json');
    String blogJson = json.encode(await blogRepository.loadAll());
    await blog.writeAsString(blogJson);

    File category = File('$path/category.json');
    String categoryJson = json.encode(await categoryRepository.loadAll());
    await category.writeAsString(categoryJson);

    final output = await getExternalStorageDirectory();
    var outputFile = Directory(output.path + "/二飞日记");
    bool outputFileExists = await outputFile.exists();
    if (!outputFileExists) {
      await outputFile.create();
    }
    String name =
        DateUtil.formatDate(DateTime.now(), format: 'yyyy_MM_dd_HH_mm_ss');
    name = 'backup-$name';
    var encoder = ZipFileEncoder();
    encoder.open(outputFile.path + "/$name.zip");
    var photo = Directory(_path.path + "/photos");
    if (await photo.exists()) {
      encoder.addDirectory(photo);
    }
    encoder.addFile(blog);
    encoder.addFile(category);
    encoder.close();

    category.deleteSync();
    blog.deleteSync();

    return File(outputFile.path + "/$name.zip");
  }

   importBlog(List<dynamic> list) async {
    await blogRepository.clear();
    await blogRepository
        .batchInsert(list.map((e) => BlogEntity.fromJson(e)).toList());
  }

   importCategory(List<dynamic> list) async {
    await categoryRepository.clear();
    await categoryRepository
        .batchInsert(list.map((e) => CategoryEntity.fromJson(e)).toList());
  }
}
