import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

import 'app_zefyr_image_delegate.dart';

class EditorPage extends StatefulWidget {
  final String content;
  final bool eidt;

  const EditorPage({Key key, this.content, this.eidt: false}) : super(key: key);

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final document = _loadDocument(widget.content);
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    return ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(16),
        controller: _controller,
        focusNode: _focusNode,
        mode: widget.eidt ? ZefyrMode.edit : ZefyrMode.view,
        imageDelegate: AppZefyrImageDelegate(),
      ),
    );
  }

  NotusDocument _loadDocument(String content) {
    Delta delta;
    try {
      delta = Delta.fromJson(jsonDecode(content));
    } catch (e) {
      delta = Delta()..insert("\n");
    }
    return NotusDocument.fromDelta(delta);
  }

  NotusDocument getDocument() {
    return _controller?.document;
  }
}
