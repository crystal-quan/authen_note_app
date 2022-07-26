import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../repository/hive_note.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<GetNote>(_onGetNote);
    on<Delete>(_onDelete);
  }
  NoteRepository noteRepository = NoteRepository(
    firestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
     box: Hive.box<HiveNote>('notes'),
  );
  late List<QueryDocumentSnapshot<Note>> notes;

  void _onGetNote(GetNote event, Emitter<HomeState> emit) async {
    // NoteRepository noteRepository = NoteRepository(
    //     firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance,box:  Hive.box<HiveNote>('notes'));
    final example = await noteRepository.getNote();

    emit(state.copyWith(listNotes: example));
  }

  /// tương tự forEach

  void _onDelete(Delete event, Emitter<HomeState> emit) async {
    await noteRepository.deleteNote(event.id);
  }
}
