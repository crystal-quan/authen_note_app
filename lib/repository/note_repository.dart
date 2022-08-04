import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  Future<bool> addNote(String title, String content) async {
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

      return addnote;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('add Note(repository) has error - $e ');
      return addnote = false;
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
      print(listNotes);
      return listNotes;
    } catch (e) {
      listNotes = null;
      return listNotes;
    }
  }

  Future<List<Note>?> getFromRemote() async {
    bool result = await InternetConnectionChecker().hasConnection;
    late List<Note>? remoteList;
    if (result) {
      try {
        final currentUser = firebaseAuth.currentUser;
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
        } else {
          remoteList = null;
        }
      } catch (e) {
        print('getNote from Remote has error - $e');
        return remoteList = null;
      }
    } else {
      remoteList = null;
    }
    return remoteList;
  }

  // Future<List<Note>> putToRemote() async {
  //   try {
  //     final currentUser = firebaseAuth.currentUser;
  //     print('check email ${currentUser?.email}');
  //     final hiveNote = await getNote();
  //     print('check hive data ${hiveNote}');
  //     if (hiveNote != null) {
  //       hiveNote.map((e) async {
  //         await firestore
  //             .collection("users")
  //             .doc("${currentUser?.email}")
  //             .collection("notes")
  //             .doc(e.id)
  //             .withConverter(
  //               fromFirestore: Note.fromFirestore,
  //               toFirestore: (Note note, _) => note.toFirestore(),
  //             )
  //             .set(e)
  //             .whenComplete(() => print('add to Frirestore complete $e'));
  //
  //         return e;
  //       }).toList();
  //       return hiveNote;
  //     } else {
  //       final List<Note> list = [];
  //       return list;
  //     }
  //   } catch (e) {
  //     print('put To Remote has error - $e');
  //     throw Error();
  //   }
  // }
}
