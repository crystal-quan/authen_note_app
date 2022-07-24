import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<HiveNote> {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() async {
  late MockHiveBox mockHiveBox;
  late MockHiveInterface hiveInterface;
  late MockFirebaseAuth auth;
  late Note mockNote;
  late NoteRepository noteRepository;
  late FakeFirebaseFirestore firestore;

  const mockEmail = 'crystalliu25081987@gmail.com';
  const mockId = 'randomString(15)';
  const mockTitle = 'Mock_title';
  const mockcontent = 'Mock_content';
  const mockTime = 'Mock_time';

  setUp(
    () async {
      hiveInterface = MockHiveInterface();
      hiveInterface.init('./');
      // hiveInterface.openBox('users');
      MockUser user = MockUser(
          uid: '1234',
          email: 'crystal_quan@gmail.com',
          displayName: 'my_name',
          phoneNumber: '0987465132');
      auth = MockFirebaseAuth(mockUser: user);
      firestore = FakeFirebaseFirestore();

      mockHiveBox = MockHiveBox();
      noteRepository = NoteRepository(
          firestore: firestore, firebaseAuth: auth, box: mockHiveBox);

      mockNote = Note(
          id: mockId,
          title: mockTitle,
          content: mockcontent,
          timeCreate: mockTime);
    },
  );

//   const expectedDumpAfterset = '''{
//   "users": {
//     "$mockEmail": {
//       "notes": {
//         "$mockId": {
//           "note id": "$mockId",
//           "title": "My_title",
//           "content": "My_content",
//           "timeCreate": "DateTime.now()"
//         }
//       }
//     }
//   }
// }''';

  test(
    'add note',
    () async {
      // noteRepository = NoteRepository(
      //     firestore: firestore, firebaseAuth: auth, box: mockHiveBox);
      print(noteRepository);

      final a = await noteRepository.addNote(mockTitle, mockcontent, mockTime);
      when(() => noteRepository.addNote(mockTitle, mockcontent, mockTime))
          .thenReturn(mockNote);

      // expect(
      //     a,
      //     equals(Note(
      //         id: ,
      //         content: mockcontent,
      //         title: mockTitle,
      //         timeCreate: mockTime)));
    },
  );
}
