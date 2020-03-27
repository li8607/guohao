import 'package:leancloud_storage/leancloud.dart';

import 'lever.dart';

class LeverRepository {
  static final LeverRepository _leverRepository = LeverRepository._internal();

  LeverRepository._internal();

  static LeverRepository get() {
    return _leverRepository;
  }

  loadLevers() async {
    LCObject.registerSubclass<Lever>('Lever', () => new Lever());
    LCQuery<Lever> query = new LCQuery<Lever>('Lever');
    return query.find();
  }
}
