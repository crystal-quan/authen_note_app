import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockNoteRepository extends Mock implements NoteRepository {}

void main() async {
  late Note mockNote;
  late NoteRepository? noteRepository;
  late FakeFirebaseFirestore firestore;
  late DocumentReference<Map<String, dynamic>> db;
  const mockEmail = 'crystalliu25081987@gmail.com';
  const mockId = 'randomString(15)';
  const mockTitle = 'Mock_title';
  const mockcontent = 'Mock_content';
  const mockTime = 'Mock_time';

  setUp(
    () {
      noteRepository = MockNoteRepository();
      firestore = FakeFirebaseFirestore();
      mockNote = Note(
          id: mockId,
          title: mockTitle,
          content: mockcontent,
          timeCreate: mockTime);
    },
  );

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

  test(
    'add note',
    () async {
      print(noteRepository);
     
          await noteRepository?.addNote(mockTitle, mockcontent, mockTime);

      // expect(
      //     check,
      //     equals(Note(
      //         id: any(),
      //         content: mockcontent,
      //         title: mockTitle,
      //         timeCreate: mockTime)));
    },
  );
}
