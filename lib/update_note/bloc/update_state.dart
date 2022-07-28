part of 'update_bloc.dart';

class UpdateState extends Equatable {
   UpdateState({this.content = '', this.title = '', this.timeUpdate});
  final String title;
  final String content;
  final DateTime? timeUpdate;

  @override
  List<Object> get props => [title, content];
  UpdateState copywith({
    String? title,
    String? content,
    DateTime? timeUpdate,
  }) {
    return UpdateState(
        title: title ?? this.title,
        content: content ?? this.content,
        timeUpdate: timeUpdate ?? this.timeUpdate);
  }
}
