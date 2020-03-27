import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class DateListTile extends StatefulWidget {
  final DateTime dateTime;
  final ValueChanged<DateTime> onChange;

  DateListTile(this.dateTime, {this.onChange});

  @override
  _DateListTileState createState() => _DateListTileState();
}

class _DateListTileState extends State<DateListTile> {
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () async {
        DateTime date = await showDatePicker(
            context: context,
            initialDate: _dateTime,
            firstDate: DateTime(1970),
            lastDate: DateTime(3000));
        if (date != null) {
          _dateTime = date;
          setState(() {});
          widget.onChange(_dateTime);
        }
      },
      child: ListTile(
          title: Text(DateUtil.formatDate(_dateTime, format: 'yyyy年MM月dd日'))),
    );
  }
}

class TimeListTile extends StatefulWidget {
  final DateTime dateTime;
  final ValueChanged<DateTime> onChange;

  TimeListTile(this.dateTime, {this.onChange});

  @override
  _TimeListTileState createState() => _TimeListTileState();
}

class _TimeListTileState extends State<TimeListTile> {
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () async {
        TimeOfDay time = await showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(_dateTime));

        if (time != null) {
          _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
              time.hour, time.minute);
          setState(() {});
          widget.onChange(_dateTime);
        }
      },
      child: ListTile(
          title: Text(DateUtil.formatDate(_dateTime, format: 'HH:mm'))),
    );
  }
}
