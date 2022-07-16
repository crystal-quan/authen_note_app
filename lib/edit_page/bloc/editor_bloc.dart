import 'package:authen_note_app/modules/note_modules.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorState()) {
    // on<EditorEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
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
    final currentUser = await FirebaseAuth.instance.currentUser;

    final db = await FirebaseFirestore.instance;
    final now = DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();
    emit(state.copywith(timeCreate: '$day-$month-$year'));
    print(state.timeCreate);
    final note = <String, dynamic>{
      "title": state.title,
      "content": state.content,
      "timeCreate": state.timeCreate,
    };
    print(currentUser?.uid);
    if (currentUser?.uid != null) {
      await db
          .collection("users")
          .doc("${currentUser!.email}")
          .collection('notes')
          .add(note);
    }
    
  }
}
