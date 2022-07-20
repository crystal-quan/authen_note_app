import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final firestore = FakeFirebaseFirestore();
  const mockEmail = 'crystalliu25081987@gmail.com';
  const mockId = 'randomString(15)';
  const mockNote = <String, dynamic>{
    'note id': '$mockId',
    'title': 'My_title',
    'content': 'My_content',
    'timeCreate': 'DateTime.now()'
  };
  const expectedDumpAfterset = '''{
  "users": {
    "$mockEmail": {
      "notes": {
        "$mockId": {
          "note id": "$mockId",
          "title": "My_title",
          "content": "My_content",
          "timeCreate": "DateTime.now()"
        }
      }
    }
  }
}''';
  final db = firestore
      .collection('users')
      .doc(mockEmail)
      .collection('notes')
      .doc(mockId);

  test(
    'set Note to fireStore return Firestore.dum()',
    () async {
      await db.set(mockNote);
      expect(firestore.dump(), equals(expectedDumpAfterset));
    },
  );

  test(
    ' get Note from fireStore return mockNote',
    () async {
      final a = await db.get();
      expect(a.data(), equals(mockNote));
    },
  );

  test('Updates notes', () async {
    await db.set(mockNote);

    await db.update({
      'timeUpdate': 'New_time',
      'title': 'New_title',
      'content': 'New_content',
    });
    expect((await db.get()).get('title'), equals('New_title'));
    expect((await db.get()).get('content'), equals('New_content'));
    expect((await db.get()).get('timeUpdate'), equals('New_time'));
  });
  test('Update fails on non-existent docs', () async {
    final instance = FakeFirebaseFirestore();
    expect(
      instance
          .collection('user')
          .doc('newEmail')
          .collection('notes')
          .doc('NewID')
          .update({'title': 'A'}),
      throwsA(isA<FirebaseException>()),
    );
  });
}
