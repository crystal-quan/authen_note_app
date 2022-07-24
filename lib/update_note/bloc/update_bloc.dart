import 'package:authen_note_app/repository/hive_note.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(const UpdateState()) {
    on<EditTitle>(_onEditTitle);
    on<EditContent>(_onEditContent);
    on<ClickUpdate>(_onClickUpdate);
  }

  void _onEditTitle(EditTitle event, Emitter<UpdateState> emit) {
    emit(state.copywith(title: event.value));
  }

  void _onEditContent(EditContent event, Emitter<UpdateState> emit) {
    emit(state.copywith(content: event.value));
  }

  void _onClickUpdate(ClickUpdate event, Emitter<UpdateState> emit) {
    final now = DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();
    emit(state.copywith(timeUpdate: '$day-$month-$year'));
    NoteRepository _noteRepository = NoteRepository(firestore: FirebaseFirestore.instance,firebaseAuth: FirebaseAuth.instance,box: Hive.box<HiveNote>('notes'));
    _noteRepository.updateNote(event.id, state.title, state.content, state.timeUpdate);
  }
}
