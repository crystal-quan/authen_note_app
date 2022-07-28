import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/repository/note_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../repository/hive_note.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.noteRepository}) : super(HomeState()) {
    on<GetNote>(_onGetNote);
    on<Delete>(_onDelete);
    on<AutoAsync>(_onAutoAsync);
  }
  NoteRepository noteRepository;
  late List<QueryDocumentSnapshot<Note>> notes;

  void _onGetNote(GetNote event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final example = await noteRepository.getNote();
      emit(state.copyWith(listNotes: example, status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error));
      print('getNote Bloc - $e');
    }
  }

  void _onDelete(Delete event, Emitter<HomeState> emit) async {
    await noteRepository.deleteNote(event.id);
  }

  void _onAutoAsync(AutoAsync event, Emitter<HomeState> emit) async {
    try {
      await noteRepository.autoAsync();
    } catch (e) {
      print('auto async(from bloc) has error  - $e ');
      throw Error();
    }
  }
}
