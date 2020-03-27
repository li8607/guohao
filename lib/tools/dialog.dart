import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:guohao/widgets/loading.dart';

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new LoadingView(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            text: "$text",
          );
        });
  }
}

class DialogUtil {
  static Future<bool> showAleartDialog(
      BuildContext context, String message) async {
    return showDialog<bool>(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.network(
                "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg",
                fit: BoxFit.fitWidth,
              ),
              title: Text('提示',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
              description: Text(
                message ?? "",
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.BOTTOM,
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                '确定',
                style: Theme.of(context).accentTextTheme.body2,
              ),
              buttonCancelText: Text(
                '取消',
                style: Theme.of(context).accentTextTheme.body2,
              ),
              onOkButtonPressed: () {
                Navigator.of(context).pop(true);
              },
              onCancelButtonPressed: () {
                Navigator.of(context).pop(false);
              },
            ));
  }
}
