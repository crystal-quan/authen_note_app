part of 'update_bloc.dart';

class UpdateState {
  const UpdateState(
      {this.content = '', this.title = '', this.timeUpdate, this.timeCreate});
  final String title;
  final String content;
  final DateTime? timeCreate;
  final DateTime? timeUpdate;

  UpdateState copywith({
    String? title,
    String? content,
    DateTime? timeCreate,
    DateTime? timeUpdate,
  }) {
    return UpdateState(
      title: title ?? this.title,
      content: content ?? this.content,
      timeCreate: timeCreate,
      timeUpdate: timeUpdate,
    );
  }
}
