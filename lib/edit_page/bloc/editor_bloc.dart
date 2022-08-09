import 'package:authen_note_app/model/status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorState()) {
    on<EditorTitle>(_onEditorTitle);
    on<EditorContent>(_onEditorContent);
  }
  void _onEditorTitle(EditorTitle event, Emitter<EditorState> emit) {
    emit(state.copywith(title: event.value));
  }

  void _onEditorContent(EditorContent event, Emitter<EditorState> emit) {
    emit(state.copywith(content: event.value));
  }
}
