import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoteRepository {
  final currentUser = FirebaseAuth.instance.currentUser;

  final db = FirebaseFirestore.instance;
  Future<void> addNote(String title, String content, String timeCreate) async {
    bool result = await InternetConnectionChecker().hasConnection;

    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    String randomId = getRandomString(15);

    Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'timeCreate': timeCreate,
      'note id': randomId,
    };
    print(randomId);

    if (result == true) {
      if (currentUser?.uid != null) {
        final a = await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .add(data);
      }
      Hive.box('notes').put(randomId, data);
      final a = Hive.box('notes').get(randomId);
      print('quanquan');
      print(a.toString());
    } else {
      print('No internet :( Reason:');
    }
  }
}
