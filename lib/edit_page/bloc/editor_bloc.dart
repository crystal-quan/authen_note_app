import 'package:authen_note_app/note_repository/note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final NoteRepository _noteRepository = NoteRepository();
  EditorBloc() : super(EditorState()) {
    on<EditorTitle>(_onEditorTitle);
    on<EditorContent>(_onEditorContent);
    on<SaveNote>(_onSaveNote);
  }
  void _onEditorTitle(EditorTitle event, Emitter<EditorState> emit) {
    emit(state.copywith(title: event.value));
  }

  void _onEditorContent(EditorContent event, Emitter<EditorState> emit) {
    emit(state.copywith(content: event.value));
  }

  void _onSaveNote(SaveNote event, Emitter<EditorState> emit) async {
    final now = DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();
    emit(state.copywith(timeCreate: '$day-$month-$year'));
    return _noteRepository.addNote(
        state.title, state.content, state.timeCreate);
  }
}
