// ignore_for_file: must_be_immutable

part of 'editor_bloc.dart';

class EditorState extends Equatable {
  EditorState({this.title='', this.content='', this.timeCreate=''});
  String title;
  String content;
  String timeCreate;

  @override
  List<Object> get props => [content,timeCreate,title];

  EditorState copywith({
    String? title,
    String? content,
    String? timeCreate,
  }) {
    return EditorState(
      content: content ?? this.content,
      timeCreate: timeCreate??this.timeCreate,
      title: title??this.title
    );
  }
}
