

part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object> get props => [];
}

class EditorTitle extends EditorEvent {
  String? value;
  EditorTitle(this.value);
}

class EditorContent extends EditorEvent {
  String value;
  EditorContent(this.value);

  @override
  List<Object> get props => [value];
}


class SaveNote extends EditorEvent {
  SaveNote();

}