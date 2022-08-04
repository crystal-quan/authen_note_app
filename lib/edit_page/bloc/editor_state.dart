// ignore_for_file: must_be_immutable

part of 'editor_bloc.dart';

class EditorState extends Equatable {
  EditorState(
      {this.title = '',
      this.content = '',
      this.timeCreate,
      this.status = Status.loading});
  String title;
  String content;
  DateTime? timeCreate;
  Status status;

  @override
  List<Object> get props => [
        content,
        title,
        status,
      ];

  EditorState copywith({
    String? title,
    String? content,
    DateTime? timeCreate,
    Status? status,
  }) {
    return EditorState(
      content: content ?? this.content,
      timeCreate: timeCreate ?? this.timeCreate,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}
