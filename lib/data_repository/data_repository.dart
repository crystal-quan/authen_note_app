import 'package:authen_note_app/modules/note_modules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final currentUser = FirebaseAuth.instance.currentUser;

final db = FirebaseFirestore.instance;

class NoteRepository {
  NoteRepository({
    this.note,
  });
  Note? note;

  void addData() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      if (currentUser?.uid != null) {
        Map<String, dynamic> data = {
          'title': note?.title,
          'content': note?.content,
          'timeCreate': note?.timeCreate,
        };
        final a = await db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .add(data);

        db
            .collection("users")
            .doc("${currentUser!.email}")
            .collection('notes')
            .doc(a.id)
            .set({'note id': a.id}, SetOptions(merge: true));
      }else{
        
      }
    } else {
      print('No internet :( Reason:');
      
    }
  }
}
