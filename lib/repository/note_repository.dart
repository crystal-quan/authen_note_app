import 'package:authen_note_app/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoteRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  late Note note;

  final db = FirebaseFirestore.instance;
  Future<Null> addNote(String title, String content, String timeCreate) async {
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
            .doc("${currentUser!.email}")
            .collection('notes')
            .add({
          'title': title,
          'note id': randomId,
          'content': content,
          'timeCreate': timeCreate
        });

        final check = await a
            .withConverter(
              fromFirestore: Note.fromFirestore,
              toFirestore: (Note note, _) => note.toFirestore(),
            )
            .get();
        final s = check.data();
        print(s);
        // return s;
      }
      await Hive.box<Note>('notes').put(randomId, note);
      final read = Hive.box<Note>('notes').get(randomId);
      print('quanquan');
      print(read);
      // return read;
    } else {
      await Hive.box<Note>('notes').put(randomId, note);
      final read = Hive.box<Note>('notes').get(randomId);
      print('quanquan');
      print(read);
      // return read;
    }
  }

  Future<void> deleteNote(String id) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == true) {
      if (currentUser?.email != null) {
        await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .delete();
      }
      final delete = await Hive.box('notes,{key}').delete(id);
    } else {
      await Hive.box('notes,{key}').delete(id);
    }
  }

  Future<void> updateNote(
      String id, String title, String content, String timeUpdate) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == true) {
      if (currentUser?.email != null) {
        await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(id)
            .update(
                {'title': title, 'content': content, 'timeUpdate': timeUpdate});
      }
      final update = await Hive.box('notes').put('Key', {
        id,
        {
          'title': title,
          'content': content,
          'timeUpdate': timeUpdate,
        }
      });
    } else {
      await Hive.box('notes').put('Key', {
        id,
        {
          'title': title,
          'content': content,
          'timeUpdate': timeUpdate,
        }
      });
    }
  }

  Future<List<Note>?> getNote() async {
    bool result = await InternetConnectionChecker().hasConnection;
    late List<Note> listNotes;

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

        final List<Note> listNote = listData.docs.map((e) => e.data()).toList();
        return listNotes = listNote;
      }

      final List<Note> notLogged = await Hive.box('notes').get('Key');
      print(notLogged.length);
    } else {
      final List<Note> notLogged = await Hive.box('notes').get('Key');
      print(notLogged.length);
    }
    return null;
  }
}
