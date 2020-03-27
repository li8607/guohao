import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class NotusDocumentUtil {
  static String getTitle(String text) {
    String title;
    try {
      NotusDocument document =
          NotusDocument.fromDelta(Delta.fromJson(jsonDecode(text)));
      title = document.toPlainText();
    } catch (e) {
      title = text;
    }
    return title;
  }

  static NotusDocument getNotusDocumentFromString(String content) {
    Delta delta;
    try {
      delta = Delta.fromJson(jsonDecode(content));
    } catch (e) {
      delta = Delta()..insert("\n");
    }
    return NotusDocument.fromDelta(delta);
  }
}
