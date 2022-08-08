import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math' as math;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoteRepository {
  NoteRepository({
    required this.firestore,
    required this.firebaseAuth,
    required this.box,
  });

  late auth.FirebaseAuth firebaseAuth;
  late Note note;
  late Box<Note> box;
  late FirebaseFirestore firestore;
  final GoogleAuthenRepository googleAuthenRepository = GoogleAuthenRepository(
      firebaseAuth: auth.FirebaseAuth.instance, googleSignIn: GoogleSignIn());

  Future<String> getRandomId() async {
    try {
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      math.Random rnd = math.Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

      String randomId = getRandomString(15);
      print(randomId);
      return randomId;
    } catch (e) {
      throw Error();
    }
  }

  Future<Note> addNote(String title, String content) async {
    bool result = await InternetConnectionChecker().hasConnection;
    final currentUser = firebaseAuth.currentUser;
    late bool addnote;
    String randomId = await getRandomId();
    Note note = Note(
      content: content,
      title: title,
      timeCreate: DateTime.now(),
      id: randomId,
      timeUpdate: DateTime.now(),
    );
    try {
      addnote = await addToLocal(randomId, note);
      if (result) {
        await addToRemote(
          randomId,
          note,
        );
      }

      return note;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('add Note(repository) has error - $e ');
      throw Error();
    }
  }

  Future<bool> addToRemote(String id, Note note) async {
    late bool addToremote;
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser?.email != null) {
        await firestore
            .collection("users")
            .doc("${currentUser?.email}")
            .collection('notes')
            .doc(id)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .set(note, SetOptions(merge: true));
        addToremote = true;
      } else {
        addToremote = false;
      }
      return addToremote;
    } catch (e, stack) {
      addToremote = false;
      log(e.toString(), error: e, stackTrace: stack);
      print('Add Note to Remote (NoteRepository) has error - $e');
      return addToremote;
      // throw Error();
    }
  }

  Future<bool> addToLocal(String id, Note note) async {
    late bool addToLocal;
    try {
      await box.put(id, note);
      addToLocal = true;
      return addToLocal;
    } catch (e) {
      print('Add Note to Local (NoteRepository) has error - $e');
      addToLocal = false;
      return addToLocal;
    }
  }

  Future<bool> deleteNote(String id, DateTime dateTime, String? title,
      String? content, DateTime? timeCreate) async {
    final note = Note(
        id: id,
        title: title,
        timeCreate: timeCreate,
        timeUpdate: dateTime,
        content: content,
        isDelete: true);
    bool result = await InternetConnectionChecker().hasConnection;
    late bool deleteNote;
    try {
      deleteNote = await deleteFromLocal(note);
      if (result) {
        await deleteFromRemote(note);
      }
      return deleteNote;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('delete Note(repository) has error - $e');
      return deleteNote = false;
    }
  }

  Future<bool> deleteFromRemote(Note note) async {
    late bool deleteComple;
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser?.email != null) {
        await firestore
            .collection("users")
            .doc("${currentUser?.email}")
            .collection('notes')
            .doc(note.id)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .set(note);
        deleteComple = true;
      } else {
        deleteComple = false;
      }
      return deleteComple;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      return deleteComple = false;
    }
  }

  Future<bool> deleteFromLocal(Note note) async {
    late bool deleteComple;
    try {
      await box.put(note.id, note);
      deleteComple = true;
      return deleteComple;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      return deleteComple = false;
    }
  }

  Future<bool> updateNote(
    String id,
    String? title,
    String? content,
    DateTime? timeCreate,
    DateTime? timeUpdate,
    bool isDelete,
  ) async {
    bool result = await InternetConnectionChecker().hasConnection;
    late bool updateNote;
    Note note = Note(
      id: id,
      title: title,
      content: content,
      timeCreate: timeCreate,
      timeUpdate: timeUpdate,
      isDelete: isDelete,
    );
    try {
      updateNote = await updateToLocal(note);
      if (result) {
        await updateToRemote(note);
      }
      return updateNote;
    } catch (e) {
      return updateNote = false;
    }
  }

  Future<bool> updateToRemote(Note note) async {
    late bool updateToRemote;
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser?.email != null) {
        await firestore
            .collection("users")
            .doc("${currentUser?.email}")
            .collection('notes')
            .doc(note.id)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .set(note, SetOptions(merge: true));
        updateToRemote = true;
      }
      return updateToRemote;
    } catch (e) {
      print('Update To Remote(noteRepository) has error - $e');
      return updateToRemote = false;
    }
  }

  Future<bool> updateToLocal(Note note) async {
    late bool updateToLocal;
    try {
      await box.put(note.id, note);
      updateToLocal = true;
      return updateToLocal;
    } catch (e) {
      print('Update To Remote(noteRepository) has error - $e');
      return updateToLocal = false;
    }
  }

  Future<List<Note>?> getNote() async {
    late List<Note>? listNotes;
    try {
      final listKey = box.keys.toList();
      final listkeytoString = listKey.map((e) => e.toString()).toList();
      listNotes = listkeytoString.map((e) {
        final hivenotte = box.get(e);
        return hivenotte ?? Note();
      }).toList();
      print('quanbv check get offline $listNotes');
      return listNotes;
    } catch (e) {
      listNotes = null;
      return listNotes;
    }
  }

  Future<List<Note>> getFromRemote() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print('quanbv check - $result');
    final currentUser = await googleAuthenRepository.getUser();
    print('quanbv check mail - ${currentUser?.email}');
    late List<Note>? remoteList;
    if (result) {
      try {
        if (currentUser?.email != null) {
          final remoteData = await firestore
              .collection('users')
              .doc('${currentUser?.email}')
              .collection('notes')
              .withConverter(
                fromFirestore: Note.fromFirestore,
                toFirestore: (Note note, _) => note.toFirestore(),
              )
              .get();
          remoteList = remoteData.docs.map((e) {
            return e.data();
          }).toList();
          print('quanbv get Online  $remoteList');
          return remoteList;
        } else {
          remoteList = [];
          return remoteList;
        }
      } catch (e) {
        print('getNote from Remote has error - $e');
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> onAutoAsync() async {
    try {
      final listRemoteData = await getFromRemote();
      final listLocalData = await getNote() ?? [];
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
            await updateToLocal(note);
          } else if (checkTime == 1) {
            final Note note = (listLocalData).elementAt(localData);
            listRemoteData[remoteData] = note;
            await updateToRemote(note);
          }
        } else {
          listLocalData.add(listRemoteData.elementAt(remoteData));
          await addToLocal(listRemoteData.elementAt(remoteData).id,
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
            await updateToRemote(note);
          } else if (checkTime == 1) {
            final Note note = (listRemoteData).elementAt(remoteData);
            listLocalData[localData] = note;
            await updateToLocal(note);
          }
        } else {
          listRemoteData.add((listLocalData).elementAt(localData));
          await addToRemote(
            (listLocalData).elementAt(localData).id,
            (listLocalData).elementAt(localData),
          );
        }
      }
      // listNoteAsync = await noteRepository.getNote() ?? [];
      // if (listNoteAsync != []) {
      //   print('quanbv check bloc1 - ${listNoteAsync}');
      //   emit(state.copyWith(
      //     listNotes: listNoteAsync
      //         .where((element) => element.isDelete == false)
      //         .toList(),
      //   ));
      // } else {
      //   listNoteAsync = await noteRepository.getFromRemote();
      //   print('quanbv check bloc2 - ${listNoteAsync}');
      //   emit(state.copyWith(
      //     listNotes: listNoteAsync
      //         .where((element) => element.isDelete == false)
      //         .toList(),
      //   ));
      // }
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('auto async(from bloc) has error  - $e ');
      throw Error();
    }
  }
}
