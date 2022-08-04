import 'package:authen_note_app/model/note_model.dart';

import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart ';

import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() async {
  late MockFirebaseAuth auth;
  late Note mockNote;
  late NoteRepository noteRepository;
  late FakeFirebaseFirestore firestore;

  const mockEmail = 'crystalliu25081987@gmail.com';
  const mockId = 'randomString-15';
  const mockTitle = 'Mock_title';
  const mockContent = 'Mock_content';
  final mockTime = DateTime.now();
  final MockUser user = MockUser(
      uid: '1234',
      email: 'crystal_quan@gmail.com',
      displayName: 'my_name',
      phoneNumber: '0987465132');
  group('constructor', () {
    test('create NoteRepository', () async {
      expect(
          NoteRepository(
              firebaseAuth: MockFirebaseAuth(mockUser: user),
              box: await Hive.openBox<Note>('notes'),
              firestore: FakeFirebaseFirestore()),
          isNotNull);
    });
  });

  setUp(
    () async {
      Hive.registerAdapter(NoteAdapter(), internal: true, override: true);
      await setUpTestHive();
      final box = await Hive.openBox<Note>('notes-testing');

      auth = MockFirebaseAuth(mockUser: user, signedIn: true);

      firestore = FakeFirebaseFirestore();

      noteRepository = NoteRepository(
        firestore: firestore,
        firebaseAuth: auth,
        box: box,
      );

      mockNote = Note(
          id: mockId,
          title: mockTitle,
          content: mockContent,
          timeCreate: mockTime);

      // when(() => noteRepository.addToRemote(mockId, mockNote))
      //     .thenAnswer((invocation) => Future.value(mockNote));
      // when(() => noteRepository.addToRemote(mockId, mockNote))
      //     .thenAnswer((invocation) async => Future.value(mockNote));
    },
  );

  test(
    'getRandom ID return String(15)',
    () async {
      final String randomId = await noteRepository.getRandomId();

      expect(randomId.length, mockId.length);
    },
  );
  test(
    'addNote To Remote Success return True',
    () async {
      final addToRemote = await noteRepository.addToRemote(mockId, mockNote);
      expect(addToRemote, true);
    },
  );
  test(
    'addNote To Local Success return True',
    () async {
      final addToRemote = await noteRepository.addToLocal(mockId, mockNote);
      expect(addToRemote, true);
    },
  );
  test(
    'addNote To Local Fail return False',
    () async {
      await Hive.box<Note>('notes-testing').close();
      final addToRemote = await noteRepository.addToLocal(mockId, mockNote);
      expect(addToRemote, false);
    },
  );

  test(
    'addNote To Remote Fail return false',
    () async {
      // noteRepository = NoteRepository(
      //   firestore: FakeFirebaseFirestore(),
      //   firebaseAuth: MockFirebaseAuth(mockUser: user, signedIn: false),
      //   box: Hive.box<Note>('notes-testing'),
      // );
      await auth.signOut();
      final addToRemote = await noteRepository.addToRemote(mockId, mockNote);

      expect(addToRemote, false);
    },
  );
  test(
    'add Note to local and Remote',
    () async {
      final addNote =
          await noteRepository.addNote(mockTitle, mockContent);
      expect(addNote, true);
    },
  );
  test(
    'add Note to local and Remote has error when add note To Local error',
    () async {
      await Hive.box<Note>('notes-testing').close();
      // await auth.signOut();
      final addNote =
          await noteRepository.addNote(mockTitle, mockContent);
      expect(addNote, false);
    },
  );
  test(
    'deleteNote From Local Success return True',
    () async {
      final deleteFormLocal = await noteRepository.deleteFromLocal(mockNote);
      expect(deleteFormLocal, true);
    },
  );

  test(
    'deleteNote From Remote Success return True',
    () async {
      final deleteFormLocal = await noteRepository.deleteFromRemote(mockNote);
      expect(deleteFormLocal, true);
    },
  );
  test(
    'deleteNote From Local Fail return false',
    () async {
      await Hive.box<Note>('notes-testing').close();
      final deleteFormLocal = await noteRepository.deleteFromLocal(mockNote);
      expect(deleteFormLocal, false);
    },
  );
  test(
    'deleteNote From Remote Fail return false',
    () async {
      await auth.signOut();
      final deleteFormLocal = await noteRepository.deleteFromRemote(mockNote);
      expect(deleteFormLocal, false);
    },
  );

  test(
    'deleteNote Fail return false',
    () async {
      await Hive.box<Note>('notes-testing').close();
      final deleteFormLocal = await noteRepository.deleteNote(
          mockId, mockTime, mockTitle, mockContent, mockTime);
      expect(deleteFormLocal, false);
    },
  );

  test(
    'deleteNote Succes return true',
    () async {
      final deleteFormLocal = await noteRepository.deleteNote(
          mockId, mockTime, mockTitle, mockContent, mockTime);
      expect(deleteFormLocal, true);
    },
  );
  test(
    'update Note To Local Success return True',
    () async {
      final updateTolocal = await noteRepository.updateToLocal(mockNote);
      expect(updateTolocal, true);
    },
  );

  test(
    'update Note To Remote Success return True',
    () async {
      final updateToRemote = await noteRepository.updateToRemote(mockNote);
      expect(updateToRemote, true);
    },
  );
  test(
    'update Note To Local Fail return false',
    () async {
      await Hive.box<Note>('notes-testing').close();
      final updateTolocal = await noteRepository.updateToLocal(mockNote);
      expect(updateTolocal, false);
    },
  );
  test(
    'update Note To Remote Fail return false',
    () async {
      await auth.signOut();
      final updateToRemote = await noteRepository.updateToRemote(mockNote);
      expect(updateToRemote, false);
    },
  );

  test(
    'getNote from Local Succes return List<Note> is not null',
    () async {
      final localNote = await noteRepository.getNote();
      expect(localNote, isNotNull);
    },
  );
  test(
    'getNote from Local Fail return List<Note> is null',
    () async {
      await Hive.box<Note>('notes-testing').close();
      final localNote = await noteRepository.getNote();
      expect(localNote, isNull);
    },
  );

  test(
    'getNote from Remote Succes return List<Note> is not null',
    () async {
      final localNote = await noteRepository.getFromRemote();
      expect(localNote, isNotNull);
    },
  );

  test(
    'getNote from Remote Fail return List<Note> is null',
    () async {
      await auth.signOut();
      final localNote = await noteRepository.getFromRemote();
      expect(localNote, isNull);
    },
  );

  tearDown(() async {
    await tearDownTestHive();
  });
}
