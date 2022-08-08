import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/model/user.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
import 'package:authen_note_app/repository/note_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.noteRepository}) : super(HomeState()) {
    on<Delete>(_onDelete);
    // on<GetOffline>(_onGetOffline);
    on<LoginWithGoogle>(_onLogInWithGoogle);
    on<CheckLogin>(_onCheckLogin);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
  }
  NoteRepository noteRepository;

  late List<QueryDocumentSnapshot<Note>> notes;
  final GoogleAuthenRepository authenticationRepository =
      GoogleAuthenRepository(
          firebaseAuth: fire_auth.FirebaseAuth.instance,
          googleSignIn: GoogleSignIn());

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await authenticationRepository.logOut();
      emit(state.copyWith(
          user: User.empty, listNotes: [], status: Status.success));
    } catch (e) {
      throw Exception('Log Out bloc error');
    }
  }

  Future<void> _onCheckLogin(
    CheckLogin event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final currentUser = await authenticationRepository.getUser();
    if (currentUser?.email != null) {
      await noteRepository.onAutoAsync();
    }

    final list = await noteRepository.getNote();
    final listNotDele =
        list?.where((element) => element.isDelete == false).toList();
    emit(state.copyWith(
        listNotes: listNotDele,
        user: currentUser,
        status: Status.success,
        loginStatus: FormzStatus.submissionSuccess));

    print('quanquan check ${state.listNotes}');
  }

  void _onLogInWithGoogle(
      LoginWithGoogle event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        loginStatus: FormzStatus.submissionInProgress, status: Status.loading));
    try {
      await authenticationRepository.logInWithGoogle();
      final currentUser = await authenticationRepository.getUser();
      print(currentUser?.email);

      if (currentUser?.email != null) {
        await noteRepository.onAutoAsync();
      }
      final list = await noteRepository.getNote();
      final listNotDele =
          list?.where((element) => element.isDelete == false).toList();
      emit(state.copyWith(
          listNotes: listNotDele,
          user: currentUser,
          status: Status.success,
          loginStatus: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: FormzStatus.submissionFailure,
        ),
      );
    }
  }

  void _onDelete(Delete event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));

    final now = DateTime.now();
    final delete = await noteRepository.deleteNote(
        event.id, now, event.title, event.content, event.timeCreate);
    final newList = state.listNotes ?? [];
    newList.removeWhere((element) => element.id == event.id);

    emit(state.copyWith(listNotes: newList, status: Status.success));
  }

  void _onAddNote(
    AddNote event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      print('quanbv check state list ${state.listNotes}');
      final saveNote = await noteRepository.addNote(
        event.title ?? '',
        event.content ?? '',
      );
      final list = state.listNotes ?? [];
      list.add(saveNote);
      print('quanbv check event add $saveNote');
      emit(state.copyWith(status: Status.addNote, listNotes: list));
      print('quanvb check sate da them ${state.listNotes}');
    } catch (e) {
      emit(state.copyWith(status: Status.error));
      print('edittor bloc error -$e');
    }
  }

  void _onUpdateNote(
    UpdateNote event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final now = DateTime.now();
    Note note = Note(
      id: event.id,
      content: event.content,
      timeCreate: event.timeCreate,
      timeUpdate: now,
      title: event.title,
      isDelete: false,
    );
    try {
      await noteRepository.updateNote(note);
      final stateNewlist = state.listNotes ?? [];
      int index = stateNewlist.indexWhere((element) => element.id == event.id);
      stateNewlist.fillRange(index, (index + 1), note);
      emit(state.copyWith(status: Status.upDateNote, listNotes: stateNewlist));
      print('quanbv check new ${state.listNotes}');
    } catch (e, s) {
      log('Update Note (Home Bloc) has error -$e', error: e, stackTrace: s);
    }
  }
}
