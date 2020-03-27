import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/label/label_entity.dart';

class LabelState extends Equatable {
  @override
  List<Object> get props => [];
}

class LabelLoadedInProgress extends LabelState {
  @override
  String toString() {
    return 'LabelLoadedInProgress';
  }
}

class LabelLoadedInitial extends LabelState {
  @override
  String toString() {
    return 'LabelLoadedInitial';
  }
}

class LabelLoadedSuccess extends LabelState {
  final List<LabelEntity> labels;
  List<LabelEntity> selectorsLabels;
  int blogId;

  LabelLoadedSuccess({this.labels});

  LabelLoadedSuccess copyWith({List<LabelEntity> labels}) {
    return LabelLoadedSuccess(labels: labels ?? this.labels);
  }

  @override
  List<Object> get props => [labels, selectorsLabels, blogId];

  @override
  String toString() {
    return 'LabelLoadedSuccess';
  }
}

class LabelLoadedFailure extends LabelState {
  @override
  String toString() {
    return 'LabelLoadedFailure';
  }
}

class LabelInsertInitial extends LabelState {
  @override
  String toString() {
    return 'LabelInsertInitial';
  }
}

class LabelInsertInProgress extends LabelState {
  @override
  String toString() {
    return 'LabelInsertInProgress';
  }
}

class LabelInsertSuccess extends LabelState {
  @override
  String toString() {
    return 'LabelInsertSuccess';
  }
}

class LabelInsertFailure extends LabelState {
  final String message;

  LabelInsertFailure(this.message);

  @override
  String toString() {
    return 'LabelInsertFailure';
  }
}

class BlogLabelInsertInProgress extends LabelState {
  @override
  String toString() {
    return "BlogLabelInsertInProgress";
  }
}

class BlogLabelInsertSuccess extends LabelState {
  @override
  String toString() {
    return "BlogLabelInsertSuccess";
  }
}

class BlogLabelInsertFailure extends LabelState {
  @override
  String toString() {
    return "BlogLabelInsertFailure";
  }
}

class BlogLabelDeleteInProgress extends LabelState {
  @override
  String toString() {
    return "BlogLabelDeleteInProgress";
  }
}

class BlogLabelDeleteSuccess extends LabelState {
  @override
  String toString() {
    return "BlogLabelDeleteSuccess";
  }
}

class BlogLabelDeleteFailure extends LabelState {
  @override
  String toString() {
    return "BlogLabelDeleteFailure";
  }
}

class LabelDeleteInProgress extends LabelState {
  @override
  String toString() {
    return "LabelDeleteInProgress";
  }
}

class LabelDeleteSuccess extends LabelState {
  @override
  String toString() {
    return "LabelDeleteSuccess";
  }
}

class LabelDeleteFailure extends LabelState {
  @override
  String toString() {
    return "LabelDeleteFailure";
  }
}
