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
  final currentUser = FirebaseAuth.instance.currentUser;
  late Note note;
  late List<String> listId;
  final box = Hive.box<HiveNote>('notes');

  final db = FirebaseFirestore.instance;
  Future<Note> addNote(String title, String content, String timeCreate) async {
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

    if (result == true) {
      if (currentUser?.uid != null) {
        final a = await db
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

        final check = await db
            .collection('users')
            .doc(currentUser!.email)
            .collection('notes')
            .doc(randomId)
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .get();
        final s = check.data() as Note;
        print(s);
        return s;
      }
      HiveNote hiveNote = HiveNote(
          content: content, title: title, timeCreate: timeCreate, id: randomId);

      await box.put(randomId, hiveNote);
      final read = box.get(randomId);
      Note kq = Note(
          id: read?.id,
          title: read?.title,
          content: read?.content,
          timeCreate: read?.timeCreate);
      print('quanquan');
      print(read);
      return kq;
    } else {
      HiveNote hiveNote = HiveNote(
          content: content, title: title, timeCreate: timeCreate, id: randomId);
      Map<String, HiveNote> map = {randomId: hiveNote};
      await box.put(randomId, hiveNote);
      final read = box.get(randomId);
      Note kq = Note(
          id: read?.id,
          title: read?.title,
          content: read?.content,
          timeCreate: read?.timeCreate);
      print('quanquan');
      print(kq.toString());
      return kq;
    }
  }

  Future<bool> deleteNote(String id) async {
    late bool deleteComple;
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == true) {
      if (currentUser?.email != null) {
        await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .delete()
            .whenComplete(() => deleteComple = true);

        return deleteComple;
      }
      final delete = await Hive.box('notes')
          .delete(id)
          .whenComplete(() => deleteComple = true);
      return deleteComple;
    } else {
      await Hive.box('notes,{key}')
          .delete(id)
          .whenComplete(() => deleteComple = true);
      print(deleteComple.toString());
      return deleteComple;
    }
  }

  Future<bool> updateNote(
      String id, String title, String content, String timeUpdate) async {
    bool result = await InternetConnectionChecker().hasConnection;
    late bool updateNote;

    if (result == true) {
      if (currentUser?.email != null) {
        await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .update({
          'title': title,
          'content': content,
          'timeUpdate': timeUpdate
        }).whenComplete(() => updateNote = true);
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
    bool result = await InternetConnectionChecker().hasConnection;
    late List<Note>? listNotes;

    if (result == true) {
      if (currentUser?.email != null) {
        final listData = await db
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
      final hiveNot = await box.get('IxcvRxG3qK7DDlu');

      // listNotes = hiveNot.map((e) {
      //   Note note = Note(
      //       id: e.id,
      //       content: e.content,
      //       title: e.title,
      //       timeCreate: e.timeCreate,
      //       timeUpdate: e.timeUpdate);
      //   return note;
      // }).toList();
      Note notte = Note(
          id: hiveNot?.id, title: hiveNot?.title, content: hiveNot?.content);
      listNotes = [notte, notte];
      print(listNotes.toString());
      return listNotes;
      // final hiveNot = await box.values.map((e) => e).toList();

      // listNotes = hiveNot.map((e) {
      //   Note note = Note(
      //       id: e.id,
      //       content: e.content,
      //       title: e.title,
      //       timeCreate: e.timeCreate,
      //       timeUpdate: e.timeUpdate);
      //   return note;
      // }).toList();
      // return listNotes;
    } else {
      final a = box.keys.toList();
      final b = a.map((e) => e.toString()).toList();
      print('key $b');
      print(a.first);
      final hivenotte = box.get(b.first);
      final c = b.map((element) {
        final hivenotte = box.get(element);
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
