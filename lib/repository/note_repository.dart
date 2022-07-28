import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';
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
  //  final box = Hive.box<HiveNote>('notes');
  FirebaseFirestore firestore;

  Future<Note> addNote(
      String title, String content, DateTime? timeCreate) async {
    // bool result = await InternetConnectionChecker().hasConnection;
    // final currentUser = firebaseAuth.currentUser;

    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    String randomId = getRandomString(15);

    note = Note(
        id: randomId, title: title, content: content, timeCreate: timeCreate);

    print(randomId);

    // return Note(id: 'a', content: 'b', title: 'c', timeCreate: 'd');

    // if (result == true) {
    //   if (currentUser?.uid != null) {
    //     await firestore
    //         .collection("users")
    //         .doc("${currentUser?.email}")
    //         .collection('notes')
    //         .doc(randomId)
    //         .set({
    //       'title': title,
    //       'note id': randomId,
    //       'content': content,
    //       'timeCreate': timeCreate
    //     });

    //     final getOneNote = await firestore
    //         .collection('users')
    //         .doc(currentUser!.email)
    //         .collection('notes')
    //         .doc(randomId)
    //         .withConverter(
    //           fromFirestore: Note.fromFirestore,
    //           toFirestore: (Note note, _) => note.toFirestore(),
    //         )
    //         .get();
    //     final oneNote = getOneNote.data() ?? Note();
    //     print(oneNote);
    //     return oneNote;
    //   }
    //   Note hiveNote = Note(
    //       content: content, title: title, timeCreate: timeCreate, id: randomId);

    //   await box.put(randomId, hiveNote);
    //   final read = box.get(randomId);
    //   Note kq = Note(
    //       id: read!.id,
    //       title: read.title,
    //       content: read.content,
    //       timeCreate: read.timeCreate);
    //   print(kq);
    //   return kq;
    // } else {
    Note hiveNote = Note(
        content: content, title: title, timeCreate: timeCreate, id: randomId);
    await box.put(randomId, hiveNote);
    final read = await box.get(randomId);
    Note kq = Note(
        id: read!.id,
        title: read.title,
        content: read.content,
        timeCreate: read.timeCreate);
    print(kq);
    return kq;
    // }
  }

  Future<bool> deleteNote(String id) async {
    // final currentUser = firebaseAuth.currentUser;
    late bool deleteComple;
    // bool result = await InternetConnectionChecker().hasConnection;
    final deleteNote = Note(id: id, isDelete: true);

    // if (result == true) {
    //   if (currentUser?.email != null) {
    //     await firestore
    //         .collection("users")
    //         .doc("${currentUser!.email}")
    //         .collection('notes')
    //         .doc(id)
    //         .withConverter(
    //             fromFirestore: Note.fromFirestore,
    //             toFirestore: (Note note, _) => note.toFirestore())
    //         .set(deleteNote, SetOptions(merge: true))
    //         .whenComplete(() => deleteComple = true);

    //     return deleteComple;
    //   }
    //   await box
    //       .put(id,deleteNote)
    //       .whenComplete(() => deleteComple = true);
    //   return deleteComple;
    // } else {
    await box.put(id, deleteNote).whenComplete(() => deleteComple = true);
    return deleteComple;
    // }
  }

  Future<bool> updateNote(
      String id, String title, String content, DateTime? timeUpdate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    late bool updateNote;
    final currentUser = firebaseAuth.currentUser;

    // if (result == true) {
    //   if (currentUser?.email != null) {
    //     await firestore
    //         .collection("users")
    //         .doc("${currentUser!.email}")
    //         .collection('notes')
    //         .doc(id)
    //         .update({
    //       'title': title,
    //       'content': content,
    //       'timeUpdate': timeUpdate
    //     }).whenComplete(() => updateNote = true);
    //     return updateNote;
    //   }
    //   Note hiveNote =
    //       Note(id: id, title: title, content: content, timeUpdate: timeUpdate);

    //   await box.put(id, hiveNote).whenComplete(() => updateNote = true);
    //   return updateNote;
    // } else {
    Note hiveNote =
        Note(id: id, title: title, content: content, timeUpdate: timeUpdate);

    await box.put(id, hiveNote).whenComplete(() => updateNote = true);
    return updateNote;
    // }
  }

  Future<List<Note>?> getNote() async {
    // final currentUser = firebaseAuth.currentUser;
    // bool result = await InternetConnectionChecker().hasConnection;
    late List<Note>? listNotes;

    // if (result == true) {
    //   if (currentUser?.email != null) {
    //     final listData = await firestore
    //         .collection("users")
    //         .doc("${currentUser!.email}")
    //         .collection('notes')
    //         .withConverter(
    //           fromFirestore: Note.fromFirestore,
    //           toFirestore: (Note note, _) => note.toFirestore(),
    //         )
    //         .get();

    //     final listNote = listData.docs.map((e) => e.data()).toList();

    //     listNote.map((e) async {
    //      await box.put(e.id, e);
    //       return;
    //     });
    //     return listNote;
    //   }

    //   final listKey = await box.keys.toList();
    //   final listkeytoString = listKey.map((e) => e.toString()).toList();
    //   final listNotes = listkeytoString.map((e) {
    //     final hivenotte = box.get(e);
    //     Note notte = Note(
    //         id: hivenotte?.id ?? '',
    //         content: hivenotte?.content,
    //         title: hivenotte?.title,
    //         timeCreate: hivenotte?.timeCreate);
    //     return notte;
    //   }).toList();
    //   return listNotes;
    // } else {
    final listKey = await box.keys.toList();
    final listkeytoString = listKey.map((e) => e.toString()).toList();
    listNotes = listkeytoString.map((e) {
      final hivenotte = box.get(e);
      Note notte = Note(
          id: hivenotte?.id ?? '',
          content: hivenotte?.content,
          title: hivenotte?.title,
          timeCreate: hivenotte?.timeCreate);
      return notte;
    }).toList();
    return listNotes;
    // }
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
        print(e.data().timeCreate);
        return e.data();
      }).toList();

      return remoteList;
    } catch (e) {
      print('getNote from Remote has error - $e');
      throw Error();
    }
  }

  Future<void> putToRemote(FirebaseAuth auth) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      final hiveNote = await getNote();
      hiveNote?.map((e) async {
        await firestore
            .collection("users")
            .doc("${currentUser?.email}")
            .collection('notes')
            .doc(e.id)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .set(e);
        return;
      });
    } catch (e) {
      print('put To Remote has error - $e');
      throw Error();
    }
  }

  Future autoAsync() async {
    try {
      await getFromRemote();
      await putToRemote(firebaseAuth);
    } catch (e) {
      print('async local and remote has error - $e');
      throw Error();
    }
  }
}
