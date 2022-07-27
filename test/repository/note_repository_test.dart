import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';

import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() async {
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
      Hive.registerAdapter(HiveNoteAdapter(), internal: true, override: true);
      await setUpTestHive();
      final box = await Hive.openBox<HiveNote>('notes-testing');
      MockUser user = MockUser(
          uid: '1234',
          email: 'crystal_quan@gmail.com',
          displayName: 'my_name',
          phoneNumber: '0987465132');
      auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      firestore = FakeFirebaseFirestore();

      noteRepository = NoteRepository(
        firestore: firestore,
        firebaseAuth: auth,
        box: box,
      );

      mockNote = Note(
          id: mockId,
          title: mockTitle,
          content: mockcontent,
          timeCreate: mockTime);
    },
  );

  test(
    'add note to Firestore',
    () async {
      print(noteRepository);

      final add =
          await noteRepository.addNote(mockTitle, mockcontent, mockTime);
      expect(add.id, isNotEmpty);
      expect(add.title, mockTitle);
      expect(add.content, mockcontent);
      expect(add.timeCreate, mockTime);
    },
  );

  test(
    'delete Note return true',
    () async {
      final delete = await noteRepository.deleteNote('');
      expect(delete, true);
    },
  );
  test(
    'Update Note return true',
    () async {
      final update = await noteRepository.updateNote(
          '', 'newTitle', 'newContent', 'newTime');
      expect(update, true);
    },
  );

  test(
    'Get Notes return List Note',
    () async {
      final getNotes = await noteRepository.getNote();
      expect(getNotes, isList);
    },
  );

  test(
    'add note to Hive_flutter',
    () async {
      await auth.signOut;
      print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');

      final add =
          await noteRepository.addNote(mockTitle, mockcontent, mockTime);
      expect(add.id, isNotEmpty);
      expect(add.title, mockTitle);
      expect(add.content, mockcontent);
      expect(add.timeCreate, mockTime);
    },
  );
  test(
    'delete Note from Hive return true',
    () async {
      print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
      final delete = await noteRepository.deleteNote('');
      expect(delete, true);
    },
  );
  test(
    'Update Note from Hive return true',
    () async {
      print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
      final update = await noteRepository.updateNote(
          '', 'newTitle', 'newContent', 'newTime');
      expect(update, true);
    },
  );

  test(
    'Get Notes from Hive return List Note',
    () async {
      print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
      final getNotes = await noteRepository.getNote();
      expect(getNotes, isList);
    },
  );

  tearDown(() async {
    await tearDownTestHive();
  });
}
