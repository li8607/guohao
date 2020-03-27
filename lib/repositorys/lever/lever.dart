import 'package:leancloud_storage/leancloud.dart';

class Lever extends LCObject {
  double get price => this['price'];

  set price(double value) => this['price'] = value;

  String get text => this['text'];

  set text(String value) => this['text'] = value;

  int get type => this['type'];

  set type(int value) => this['type'] = value;

  Lever() : super('Lever');
}
