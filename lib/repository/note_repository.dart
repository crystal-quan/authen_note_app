import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth firebaseAuth;
  late Note note;
  late Box<Note> box;

  FirebaseFirestore firestore;

  Future<bool> addNote(
      String title, String content, DateTime? timeCreate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    final currentUser = firebaseAuth.currentUser;

    try {
      late bool addNote;
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      math.Random rnd = math.Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

      String randomId = getRandomString(15);
      print(randomId);
      Note note = Note(
          content: content, title: title, timeCreate: timeCreate, id: randomId);
      await addToLocal(randomId, note).whenComplete(() => addNote = true);
      print('addnote Success');
      if (result == true) {
        return await addToRemote(randomId, note);
      }
      return addNote;
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      print('add Note(repository) has error - $e ');
      throw Error();
    }
  }

  Future<bool> addToRemote(String id, Note note) async {
    try {
      late bool addToRemote;

      await box.put(id, note).whenComplete(() => addToRemote = true);
      return addToRemote;
    } catch (e) {
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

  Future<bool> deleteNote(String id, DateTime dateTime) async {
    try {
      late bool deleteComple;
      final currentUser = firebaseAuth.currentUser;
      final note = Note(id: id, isDelete: true, timeUpdate: dateTime);

      await box.put(id, note).whenComplete(() => deleteComple = true);
      final a = box.get(id);
      print('check delete ${a?.isDelete}');
      await firestore
          .collection("users")
          .doc("${currentUser?.email}")
          .collection('notes')
          .doc(id)
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .set(note, SetOptions(merge: true))
          .whenComplete(() => deleteComple = true);
      return deleteComple;
    } catch (e) {
      print('delete Note(repository) has error - $e');
      throw Error();
    }
  }

  Future<bool> updateNote(
      String id, String? title, String? content, DateTime? timeUpdate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    late bool updateNote;

    updateNote = await updateToLocal(id, title, content, timeUpdate);
    if (result) {
      return await updateToRemote(id, title, content, timeUpdate);
    }
    return updateNote;
  }

  Future<bool> updateToRemote(
      String id, String? title, String? content, DateTime? timeUpdate) async {
    try {
      late bool updateToRemote;
      final currentUser = firebaseAuth.currentUser;
      Note hiveNote = Note(
          id: id,
          title: title,
          content: content,
          timeUpdate: timeUpdate,
          isDelete: false);
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
      String id, String? title, String? content, DateTime? timeUpdate) async {
    try {
      late bool updateToLocal;

      Note hiveNote = Note(
          id: id,
          title: title,
          content: content,
          timeUpdate: timeUpdate,
          isDelete: false);
      await box.put(id, hiveNote).whenComplete(() => updateToLocal = true);
      return updateToLocal;
    } catch (e) {
      print('Update To Remote(noteRepository) has error - $e');
      throw Error();
    }
  }

  Future<List<Note>?> getNote() async {
    late List<Note>? listNotes;

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

  Future<List<Note>> getFromRemote() async {
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
        print('check Time - ${e.data().timeCreate}');
        // box.put(e.id, e.data());
        return e.data();
      }).toList();

      return remoteList;
    } catch (e) {
      print('getNote from Remote has error - $e');
      throw Error();
    }
  }

  void check() async {
    try {
      int i;
      final remoteList = await getFromRemote();
      final localList = await getNote();
      for (i = 0; i <= remoteList.length; i++) {
        final sync =
            localList?.where((element) => element.id == remoteList[i].id);
      }
    } catch (e) {
      throw Error();
    }
  }

  Future<List<Note>> putToRemote() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      print('check email ${currentUser?.email}');
      final hiveNote = await getNote();
      print('check hive data ${hiveNote}');
      if (hiveNote != null) {
        hiveNote.map((e) async {
          await firestore
              .collection("users")
              .doc("${currentUser?.email}")
              .collection("notes")
              .doc(e.id)
              .withConverter(
                fromFirestore: Note.fromFirestore,
                toFirestore: (Note note, _) => note.toFirestore(),
              )
              .set(e)
              .whenComplete(() => print('add to Frirestore complete $e'));

          return e;
        }).toList();
        return hiveNote;
      } else {
        final List<Note> list = [];
        return list;
      }
    } catch (e) {
      print('put To Remote has error - $e');
      throw Error();
    }
  }

  Future autoAsync() async {
    try {
      await putToRemote();
      await getFromRemote();
      final hiveNote = await getNote();
      print('check hive data ${hiveNote}');
    } catch (e) {
      print('async local and remote has error - $e');
      throw Error();
    }
  }
}
