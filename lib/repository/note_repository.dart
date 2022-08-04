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

  Future<Note> addNote(
      String title, String content, DateTime? timeCreate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    final currentUser = firebaseAuth.currentUser;

    try {
      late Note addNote;
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      math.Random rnd = math.Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

      String randomId = getRandomString(15);
      print(randomId);
      Note note = Note(
        content: content,
        title: title,
        timeCreate: timeCreate,
        id: randomId,
        timeUpdate: timeCreate,
      );
      await addToLocal(randomId, note).whenComplete(() => addNote = Note(
            id: randomId,
            content: content,
            timeCreate: timeCreate,
            title: title,
            timeUpdate: timeCreate,
          ));
      print('addnote Success');
      if (result) {
        return await addToRemote(
          randomId,
          note,
        );
      }
      return addNote;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('add Note(repository) has error - $e ');
      throw Error();
    }
  }

  Future<Note> addToRemote(String id, Note note) async {
    try {
      final currentUser = firebaseAuth.currentUser;

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
      return note;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('Add Note to Remote (NoteRepository) has error - $e');
      throw Error();
    }
  }

  Future<bool> addToLocal(String id, Note note) async {
    try {
      late bool addToLocal;

      await box.put(id, note).whenComplete(() => addToLocal = true);
      return addToLocal;
    } catch (e) {
      print('Add Note to Local (NoteRepository) has error - $e');
      throw Error();
    }
  }

  Future<bool> deleteNote(String id, DateTime dateTime, String? title,
      String? content, DateTime? timeCreate) async {
    try {
      final note = Note(
          id: id,
          title: title,
          timeCreate: timeCreate,
          timeUpdate: dateTime,
          content: content,
          isDelete: true);
      bool result = await InternetConnectionChecker().hasConnection;
      final deleteFromAll = await deleteFromLocal(note);

      if (result) {
        await deleteFromRemote(note);
      }
      return deleteFromAll;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('delete Note(repository) has error - $e');
      throw Error();
    }
  }

  Future<bool> deleteFromRemote(Note note) async {
    try {
      late bool deleteComple;

      final currentUser = firebaseAuth.currentUser;
      await firestore
          .collection("users")
          .doc("${currentUser?.email}")
          .collection('notes')
          .doc(note.id)
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .set(note)
          .whenComplete(() => deleteComple = true);

      return deleteComple;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      throw Error();
    }
  }

  Future<bool> deleteFromLocal(Note note) async {
    try {
      late bool deleteComple;

      await box.put(note.id, note).whenComplete(() => deleteComple = true);
      print('xoá note ${note.isDelete}');
      return deleteComple;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      throw Error();
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

    updateNote = await updateToLocal(
      id,
      title,
      content,
      timeCreate,
      timeUpdate,
      isDelete,
    );
    if (result) {
      return await updateToRemote(
        id,
        title,
        content,
        timeUpdate,
        isDelete,
      );
    }
    return updateNote;
  }

  Future<bool> updateToRemote(
    String id,
    String? title,
    String? content,
    DateTime? timeUpdate,
    bool? isDelete,
  ) async {
    try {
      late bool updateToRemote;
      final currentUser = firebaseAuth.currentUser;
      Note hiveNote = Note(
          id: id,
          title: title,
          content: content,
          timeUpdate: timeUpdate,
          isDelete: isDelete);
      await firestore
          .collection("users")
          .doc("${currentUser?.email}")
          .collection('notes')
          .doc(id)
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .set(hiveNote, SetOptions(merge: true))
          .whenComplete(() => updateToRemote = true);
      return updateToRemote;
    } catch (e) {
      print('Update To Remote(noteRepository) has error - $e');
      throw Error();
    }
  }

  Future<bool> updateToLocal(
    String id,
    String? title,
    String? content,
    DateTime? timeCreate,
    DateTime? timeUpdate,
    bool? isDelete,
  ) async {
    try {
      late bool updateToLocal;

      Note hiveNote = Note(
        id: id,
        title: title,
        content: content,
        timeCreate: timeCreate,
        timeUpdate: timeUpdate,
        isDelete: isDelete,
      );
      await box.put(id, hiveNote).whenComplete(() => updateToLocal = true);
      return updateToLocal;
    } catch (e) {
      print('Update To Remote(noteRepository) has error - $e');
      throw Error();
    }
  }

  Future<List<Note>> getNote() async {
    late List<Note> listNotes;

    final listKey = await box.keys.toList();
    final listkeytoString = listKey.map((e) => e.toString()).toList();
    listNotes = listkeytoString.map((e) {
      final hivenotte = box.get(e);
      Note notte = Note(
          id: hivenotte?.id ?? '',
          content: hivenotte?.content,
          title: hivenotte?.title,
          isDelete: hivenotte?.isDelete,
          timeUpdate: hivenotte?.timeUpdate,
          timeCreate: hivenotte?.timeCreate);
      return notte;
    }).toList();
    return listNotes;
  }

  Future<List<Note>?> getFromRemote() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      final remoteData = await firestore
          .collection('users')
          .doc('${currentUser?.email}')
          .collection('notes')
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .get();
      final remoteList = remoteData.docs.map((e) {
        return e.data();
      }).toList();

      return remoteList;
    } catch (e) {
      print('getNote from Remote has error - $e');
      throw Error();
    }
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
