import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/repository/note_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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
    await noteRepository.deleteNote(
        event.id, now, event.title, event.content, event.timeCreate);
  }

  void _onAutoAsync(AutoAsync event, Emitter<HomeState> emit) async {
    try {
      final listRemoteData = await noteRepository.getFromRemote() ?? [];
      final listLocalData = await noteRepository.getNote();
      for (int remoteData = 0;
          remoteData < listRemoteData.length;
          remoteData++) {
        final int localData = (listLocalData).indexWhere(
            (element) => element.id == listRemoteData.elementAt(remoteData).id);
        if (localData > -1) {
          final checkTime = (listLocalData)
              .elementAt(localData)
              .timeUpdate
              ?.compareTo((listRemoteData).elementAt(remoteData).timeUpdate ??
                  DateTime.now());
          if (checkTime == -1) {
            final Note note = listRemoteData.elementAt(remoteData);
            listLocalData[localData] = note;
            await noteRepository.updateToLocal(note.id, note.title,
                note.content, note.timeCreate, note.timeUpdate, note.isDelete);
          } else if (checkTime == 1) {
            final Note note = (listLocalData).elementAt(localData);
            listRemoteData[remoteData] = note;
            await noteRepository.updateToRemote(note.id, note.title,
                note.content, note.timeUpdate, note.isDelete);
          }
        } else {
          listLocalData.add(listRemoteData.elementAt(remoteData));
          await noteRepository.addToLocal(
              listRemoteData.elementAt(remoteData).id,
              listRemoteData.elementAt(remoteData));
        }
      }

      for (var localData = 0; localData < (listLocalData).length; localData++) {
        final int remoteData = (listRemoteData).indexWhere(
            (element) => element.id == listRemoteData.elementAt(localData).id);
        if (remoteData > -1) {
          final checkTime = (listRemoteData)
              .elementAt(remoteData)
              .timeUpdate
              ?.compareTo((listLocalData).elementAt(localData).timeUpdate ??
                  DateTime.now());
          if (checkTime == -1) {
            final Note note = (listLocalData).elementAt(localData);
            listRemoteData[remoteData] = note;
            await noteRepository.updateToRemote(note.id, note.title,
                note.content, note.timeUpdate, note.isDelete);
          } else if (checkTime == 1) {
            final Note note = (listRemoteData).elementAt(remoteData);
            listLocalData[localData] = note;
            await noteRepository.updateToLocal(note.id, note.title,
                note.content, note.timeCreate, note.timeUpdate, note.isDelete);
          }
        } else {
          listRemoteData.add((listLocalData).elementAt(localData));
          await noteRepository.addToRemote(
            (listLocalData).elementAt(localData).id,
            (listLocalData).elementAt(localData),
          );
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
