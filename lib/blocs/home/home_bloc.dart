import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:guohao/blocs/home/home_event.dart';
import 'package:guohao/blocs/home/home_state.dart';
import 'package:guohao/repositorys/app_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository appRepository;

  HomeBloc({this.appRepository});

  @override
  HomeState get initialState => AppStartInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AppExported) {
      yield* _mapExportAppToState(event);
    } else if (event is AppImported) {
      yield* _mapImportAppToState(event);
    }
  }

  Stream<HomeState> _mapAppStartedToState() async* {
    yield AppStartSuccess();
  }

  Stream<HomeState> _mapImportAppToState(AppImported event) async* {
    yield ImportAppInProgress();
    var d = await getTemporaryDirectory();
    var out = d.path;
    String path = event.path;
    File file = File(path);
    var archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    for (ArchiveFile file in archive) {
      String filename = file.name;
      List<int> data = file.content;
      new File('$out/' + filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }
    //新建数据库内容
    File bolgFile = File('$out/blog.json');
    List<dynamic> blogJson = jsonDecode(await bolgFile.readAsString());
    await appRepository.importBlog(blogJson);

    //新建数据库内容
    File categoryFile = File('$out/category.json');
    List<dynamic> categoryJson = jsonDecode(await categoryFile.readAsString());
    await appRepository.importCategory(categoryJson);

    yield ImportAppSuccess();
    add(AppStarted());
  }

  Stream<HomeState> _mapExportAppToState(AppExported event) async* {
    try {
      yield ExportAppInProgress();
      File file = await appRepository.export();
      if (file == null) {
        print('file file == null');
        yield ExportAppFailure();
        return;
      }
      print('file ${file.path}');
      yield ExportAppSuccess(file.path);
    } catch (_) {
      print('file ${_}');
      yield ExportAppFailure();
    }
  }
}
