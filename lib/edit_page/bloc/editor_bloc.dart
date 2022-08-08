import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
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

  void _onSaveNote(SaveNote event, Emitter<EditorState> emit) async {}
}
