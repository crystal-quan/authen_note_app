import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hive_flutter/hive_flutter.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState()) {
    on<EditTitle>(_onEditTitle);
    on<EditContent>(_onEditContent);
    on<ClickUpdate>(_onClickUpdate);
  }

  void _onEditTitle(EditTitle event, Emitter<UpdateState> emit) {
    emit(state.copywith(title: event.value ?? event.defaulValue));
  }

  void _onEditContent(EditContent event, Emitter<UpdateState> emit) {
    emit(state.copywith(content: event.value ?? event.defaulValue));
  }

  void _onClickUpdate(ClickUpdate event, Emitter<UpdateState> emit) {
    final now = DateTime.now();

    emit(state.copywith(timeUpdate: now, timeCreate: event.timeCreate));

    NoteRepository noteRepository = NoteRepository(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: auth.FirebaseAuth.instance,
      box: Hive.box<Note>('notes'),
    );
    noteRepository.updateNote(event.id, state.title, state.content,
        state.timeCreate, state.timeUpdate, false);
    print(state.title);
    print(state.content);
  }
}
