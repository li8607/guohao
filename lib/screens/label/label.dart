import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guohao/blocs/label/label_bloc.dart';
import 'package:guohao/blocs/label/label_event.dart';
import 'package:guohao/blocs/label/label_state.dart';
import 'package:guohao/screens/label/label_list.dart';
import 'package:guohao/widgets/result.dart';

class LabelPage extends StatefulWidget {
  @override
  _LabelPageState createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LabelBloc>(context).add(LabelsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabelBloc, LabelState>(condition: (pstate, cstate) {
      return cstate is LabelLoadedSuccess ||
          cstate is LabelLoadedInProgress ||
          cstate is LabelLoadedFailure;
    }, builder: (context, state) {
      if (state is LabelLoadedSuccess) {
        return Scaffold(
          appBar: AppBar(
            title: Text('标签'),
          ),
          body: Container(
            child: LabelListView(labels: state.labels ?? []),
          ),
        );
      } else {
        return ResultView();
      }
    });
  }
}
