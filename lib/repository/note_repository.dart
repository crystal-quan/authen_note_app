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
  Box box;
  // final box = Hive.box<HiveNote>('notes');
  FirebaseFirestore firestore;

  addNote(String title, String content, String timeCreate) async {
    final currentUser = firebaseAuth.currentUser;
    bool result = await InternetConnectionChecker().hasConnection;

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

    if (result == true) {
      if (currentUser?.uid != null) {
        await firestore
            .collection("users")
            .doc("${currentUser?.email}")
            .collection('notes')
            .doc(randomId)
            .set({
          'title': title,
          'note id': randomId,
          'content': content,
          'timeCreate': timeCreate
        });

        final getOneNote = await firestore
            .collection('users')
            .doc(currentUser!.email)
            .collection('notes')
            .doc(randomId)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .get();
        final oneNote = getOneNote.data() as Note;
        print(oneNote);
        return oneNote;
      }
      HiveNote hiveNote = HiveNote(
          content: content, title: title, timeCreate: timeCreate, id: randomId);

      await box.put(randomId, hiveNote);
      final read = box.get(randomId);
      Note kq = Note(
          id: read!.id,
          title: read.title,
          content: read.content,
          timeCreate: read.timeCreate);
      return kq;
    } else {
      HiveNote hiveNote = HiveNote(
          content: content, title: title, timeCreate: timeCreate, id: randomId);
      await box.put(randomId, hiveNote);
      final read = await box.get(randomId);
      Note kq = Note(
          id: read!.id,
          title: read.title,
          content: read.content,
          timeCreate: read.timeCreate);
      return kq;
    }
  }

  Future<bool> deleteNote(String id) async {
    final currentUser = firebaseAuth.currentUser;
    late bool deleteComple;
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == true) {
      if (currentUser?.email != null) {
        await firestore
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .delete()
            .whenComplete(() => deleteComple = true);

        return deleteComple;
      }
      await box.delete(id).whenComplete(() => deleteComple = true);
      return deleteComple;
    } else {
      await box.delete(id).whenComplete(() => deleteComple = true);
      print(deleteComple.toString());
      return deleteComple;
    }
  }

  Future<bool> updateNote(
      String id, String title, String content, String timeUpdate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    late bool updateNote;
    final currentUser = firebaseAuth.currentUser;

    if (result == true) {
      if (currentUser?.email != null) {
        await firestore
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .update({
          'title': title,
          'content': content,
          'timeUpdate': timeUpdate
        }).whenComplete(() => updateNote = true);
        return updateNote;
      }
      HiveNote hiveNote = HiveNote(
          id: id, title: title, content: content, timeUpdate: timeUpdate);

      await box.put(id, hiveNote).whenComplete(() => updateNote = true);
      return updateNote;
    } else {
      HiveNote hiveNote = HiveNote(
          id: id, title: title, content: content, timeUpdate: timeUpdate);

      await box.put(id, hiveNote).whenComplete(() => updateNote = true);
      return updateNote;
    }
  }

  Future<List<Note>> getNote() async {
    final currentUser = firebaseAuth.currentUser;
    bool result = await InternetConnectionChecker().hasConnection;
    late List<Note>? listNotes;

    if (result == true) {
      if (currentUser?.email != null) {
        final listData = await firestore
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .get();

        final listNote = listData.docs.map((e) => e.data()).toList();
        await box.clear();
        return listNote;
      }
      final a = box.keys.toList();
      final b = a.map((e) => e.toString()).toList();

      final c = b.map((e) {
        final hivenotte = box.get(e);
        Note notte = Note(
            id: hivenotte!.id,
            content: hivenotte.content,
            title: hivenotte.title,
            timeCreate: hivenotte.timeCreate);
        return notte;
      }).toList();
      listNotes = c;
      return listNotes;
    } else {
      final a = box.keys.toList();
      final b = a.map((e) => e.toString()).toList();
      final c = b.map((e) {
        final hivenotte = box.get(e);
        Note notte = Note(
            id: hivenotte!.id,
            content: hivenotte.content,
            title: hivenotte.title,
            timeCreate: hivenotte.timeCreate);
        return notte;
      }).toList();
      listNotes = c;
      return listNotes;
    }
  }
}
