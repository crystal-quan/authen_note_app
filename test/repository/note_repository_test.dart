import 'package:authen_note_app/model/note_model.dart';

import 'package:authen_note_app/repository/note_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
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
  const mockId = 'randomString(15)';
  const mockTitle = 'Mock_title';
  const mockContent = 'Mock_content';
  final mockTime = DateTime.now();
  final MockUser user = MockUser(
      uid: '1234',
      email: 'crystal_quan@gmail.com',
      displayName: 'my_name',
      phoneNumber: '0987465132');

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
    'addNote To Remote return Note',
    () async {
      final addToRemote = await noteRepository.addToRemote(mockId, mockNote);

      expect(addToRemote, equals(mockNote));
    },
  );
  test(
    'addNote To Remote return Error',
    () async {
      // noteRepository = NoteRepository(
      //   firestore: FakeFirebaseFirestore(),
      //   firebaseAuth: MockFirebaseAuth(mockUser: user, signedIn: false),
      //   box: await Hive.openBox<Note>('notes-testing'),
      // );
      when(() async => await firestore
          .collection("users")
          .doc("${mockEmail}")
          .collection('notes')
          .doc(mockId)
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .set(mockNote, SetOptions(merge: true))).thenThrow(Error());
      final addToRemote = await noteRepository.addToRemote(mockId, mockNote);

      expect(addToRemote, equals(Error()));
    },
  );
  // test(
  //   'add note to Firestore',
  //   () async {
  //     final add =
  //         await noteRepository.addNote(mockTitle, mockContent, mockTime);
  //     expect(add.id, isNotEmpty);
  //     expect(add.title, mockTitle);
  //     expect(add.content, mockContent);
  //     expect(add.timeCreate, mockTime);
  //   },
  // );

  // test(
  //   'delete Note return true',
  //   () async {
  //     final delete = await noteRepository.deleteNote();
  //     expect(delete, true);
  //   },
  // );
  // test(
  //   'Update Note return true',
  //   () async {
  //     final update = await noteRepository.updateNote(
  //         '', 'newTitle', 'newContent', 'newTime');
  //     expect(update, true);
  //   },
  // );

  // test(
  //   'Get Notes return List Note',
  //   () async {
  //     final getNotes = await noteRepository.getNote();
  //     expect(getNotes, isList);
  //   },
  // );

  // test(
  //   'add note to Hive_flutter',
  //   () async {
  //     await auth.signOut;
  //     print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');

  //     final add =
  //         await noteRepository.addNote(mockTitle, mockcontent, mockTime);
  //     expect(add.id, isNotEmpty);
  //     expect(add.title, mockTitle);
  //     expect(add.content, mockcontent);
  //     expect(add.timeCreate, mockTime);
  //   },
  // );
  // test(
  //   'delete Note from Hive return true',
  //   () async {
  //     print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
  //     final delete = await noteRepository.deleteNote('');
  //     expect(delete, true);
  //   },
  // );
  // test(
  //   'Update Note from Hive return true',
  //   () async {
  //     print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
  //     final update = await noteRepository.updateNote(
  //         '', 'newTitle', 'newContent', 'newTime');
  //     expect(update, true);
  //   },
  // );

  // test(
  //   'Get Notes from Hive return List Note',
  //   () async {
  //     print('check login - ${noteRepository.firebaseAuth.currentUser?.uid}');
  //     final getNotes = await noteRepository.getNote();
  //     expect(getNotes, isList);
  //   },
  // );

  tearDown(() async {
    await tearDownTestHive();
  });
}
