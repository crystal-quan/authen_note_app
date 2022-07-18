part of 'update_bloc.dart';

class UpdateState extends Equatable {
  const UpdateState({this.content = '', this.title = '', this.timeUpdate = ''});
  final String title;
  final String content;
  final String timeUpdate;

  @override
  List<Object> get props => [timeUpdate, title, content];
  UpdateState copywith({
    String? title,
    String? content,
    String? timeUpdate,
  }) {
    return UpdateState(
        title: title ?? this.title,
        content: content ?? this.content,
        timeUpdate: timeUpdate ?? this.timeUpdate);
  }
}
