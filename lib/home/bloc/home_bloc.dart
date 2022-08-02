import 'dart:developer';

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
      final example = await noteRepository.getNote() ??
          await noteRepository.getFromRemote();
      final result =
          await example.where((element) => element.isDelete == false).toList();
      print('check isdelete ${result}');
      emit(state.copyWith(listNotes: result, status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error));
      print('getNote Bloc - $e');
    }
  }

  void _onDelete(Delete event, Emitter<HomeState> emit) async {
    final now = DateTime.now();
    await noteRepository.deleteNote(event.id, now, event.title, event.content, event.timeCreate);
  }

  void _onAutoAsync(AutoAsync event, Emitter<HomeState> emit) async {
    try {
      final listRemoteData = await noteRepository.getFromRemote() ?? [];
      final listLocalData = await noteRepository.getNote() ?? [];
      for (var i = 0; i < listRemoteData.length; i++) {
        final int a = (listLocalData ?? []).indexWhere(
            (element) => element.id == listRemoteData.elementAt(i).id);
        if (a > -1) {
          final checkTime = (listLocalData ?? [])
              .elementAt(a)
              .timeUpdate
              ?.compareTo(
                  (listRemoteData).elementAt(i).timeUpdate ?? DateTime.now());
          if (checkTime == -1) {
            final Note note = listRemoteData.elementAt(i);
            listLocalData[a] = note;
            await noteRepository.updateToLocal(
                note.id, note.title, note.content, note.timeUpdate,note.isDelete);
          } else if (checkTime == 1) {
            final Note note = (listLocalData ?? []).elementAt(a);
            listRemoteData[i] = note;
            await noteRepository.updateToRemote(
                note.id, note.title, note.content, note.timeUpdate,note.isDelete);
          }
        } else {
          listLocalData.add(listRemoteData.elementAt(i));
          await noteRepository.addToLocal(
              listRemoteData.elementAt(i).id, listRemoteData.elementAt(i));
        }
      }

      for (var i = 0; i < (listLocalData ?? []).length; i++) {
        final int a = (listRemoteData).indexWhere(
            (element) => element.id == listRemoteData.elementAt(i).id);
        if (a > -1) {
          final checkTime = (listRemoteData).elementAt(a).timeUpdate?.compareTo(
              (listLocalData ?? []).elementAt(i).timeUpdate ?? DateTime.now());
          if (checkTime == -1) {
            final Note note = (listLocalData ?? []).elementAt(i);
            listRemoteData[a] = note;
            await noteRepository.updateToRemote(
                note.id, note.title, note.content, note.timeUpdate,note.isDelete);
          } else if (checkTime == 1) {
            final Note note = (listRemoteData).elementAt(a);
            listLocalData[i] = note;
            await noteRepository.updateToLocal(
                note.id, note.title, note.content, note.timeUpdate,note.isDelete);
          }
        } else {
          listRemoteData.add((listLocalData ?? []).elementAt(i));
          await noteRepository.addToRemote(
              (listLocalData ?? []).elementAt(i).id,
              (listLocalData ?? []).elementAt(i));
        }

        emit(state.copyWith(
          listNotes: listLocalData
              .where((element) => element.isDelete == false)
              .toList(),
        ));
      }
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('auto async(from bloc) has error  - $e ');
      throw Error();
    }
  }
}
