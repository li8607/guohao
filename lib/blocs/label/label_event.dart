import 'package:equatable/equatable.dart';
import 'package:guohao/repositorys/label/label_entity.dart';

class LabelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LabelLoaded extends LabelEvent {
  final int blogId;
  LabelLoaded(this.blogId);
  @override
  List<Object> get props => [blogId];
}

class LabelsLoaded extends LabelEvent {
  @override
  List<Object> get props => [];
}

class LabelInserted extends LabelEvent {
  // final LabelEntity label;

  final String label;

  LabelInserted({this.label});

  @override
  List<Object> get props => [label];
}

class BlogLabelInserted extends LabelEvent {
  final LabelEntity label;
  final int blogId;
  BlogLabelInserted(this.blogId, this.label);

  @override
  List<Object> get props => [label, blogId];

  @override
  String toString() {
    return 'BlogLabelInserted';
  }
}

class BlogLabelDeleted extends LabelEvent {
  final LabelEntity label;
  final int blogId;
  BlogLabelDeleted(this.blogId, this.label);

  @override
  List<Object> get props => [label, blogId];

  @override
  String toString() {
    return 'BlogLabelDeleted';
  }
}

class LabelDeleted extends LabelEvent {
  final int labelId;
  LabelDeleted({this.labelId});

  @override
  List<Object> get props => [labelId];

  @override
  String toString() {
    return 'LabelDeleted';
  }
}

class LabelsRefreshed extends LabelEvent {
  @override
  String toString() {
    return 'LabelsRefreshed';
  }
}
