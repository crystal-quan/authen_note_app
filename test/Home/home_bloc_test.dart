import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/model/user.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';

import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockGoogleAuthenRepository extends Mock
    implements GoogleAuthenRepository {}

void main() {
  // late MockFirebaseAuth auth;
  late MockNoteRepository mockNoteRepository;
  // late FakeFirebaseFirestore firestore;
  // late GoogleAuthenRepository googleRepo;
  // late GoogleSignIn googleSignIn;
  // late Box<User> userBox;
  late MockGoogleAuthenRepository mockGoogleAuthenRepository;

  final Note note = Note(
    id: 'randomId',
    content: 'mockContent',
    timeCreate: DateTime.now(),
    title: 'MockTitle',
    timeUpdate: DateTime.now(),
  );

  late HomeBloc homeBloc;
  late List<Note> listNotes;
  late Box<Note> box;
  setUp(
    () async {
      mockGoogleAuthenRepository = MockGoogleAuthenRepository();
      // await setUpTestHive();
      // await Hive.initFlutter();

      // Hive.registerAdapter(
      //   NoteAdapter(),
      //   internal: true,
      //   override: true,
      // );

      // Hive.registerAdapter(UserAdapter(), internal: true, override: true);

      // await Hive.openBox<Note>('notes-testing');
      // await Hive.openBox<User>('users-testing');
      // userBox = Hive.box<User>('users-testing');
      // box = Hive.box<Note>('notes-testing');
      // MockUser mockUser = MockUser(
      //   isAnonymous: false,
      //   uid: '1234',
      //   email: 'crystal_quan@gmail.com',
      //   displayName: 'my_name',
      // );
      // User user = const User(
      //     id: '1234', email: 'crystal_quan@gmail.com', name: 'my_name');

      // googleSignIn = MockGoogleSignIn();

      // final signinAccount = await googleSignIn.signIn();
      // final googleAuth = await signinAccount!.authentication;
      // final fire_auth.AuthCredential credential =
      //     fire_auth.GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // auth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      // googleRepo = GoogleAuthenRepository(
      //   firebaseAuth: auth,
      //   googleSignIn: googleSignIn,
      //   userBox: userBox,
      // );
      // firestore = FakeFirebaseFirestore();
      noteRepository = NoteRepository(
          firestore: firestore,
          box: box,
          firebaseAuth: auth,
          googleAuthenRepository: mockGoogleAuthenRepository);
      homeBloc = HomeBloc(noteRepository: noteRepository);
      listNotes = <Note>[note];
      when(() => mockGoogleAuthenRepository.logInWithGoogle())
          .thenAnswer((invocation) async => await Future.value(user));
    },
  );

  test('initial state is HomeState', () {
    expect(homeBloc.state, HomeState());
  });

  blocTest(
    'emit nothing when NoteRepo is null',
    build: () => HomeBloc(noteRepository: noteRepository),
    act: (bloc) => bloc.add(GetNote()),
    expect: () => <HomeState>[HomeState(listNotes: null)],
  );
  blocTest<HomeBloc, HomeState>(
    'emits listNote when GetNote is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(GetNote()),
    expect: () => <HomeState>[
      HomeState(listNotes: [note])
    ],
  );
  blocTest<HomeBloc, HomeState>(
    'emit Status [loading , addNote] when AddNote',
    setUp: () {
      when(() => noteRepository.addNote(note.title ?? '', note.content ?? ''))
          .thenAnswer((invocation) async => await Future.value(note));
    },
    build: () => homeBloc,
    act: (bloc) => bloc.add(AddNote()),
    expect: () => <HomeState>[
      HomeState(status: Status.loading),
      HomeState(status: Status.addNote, listNotes: [note])
    ],
  );
  // blocTest<EditorBloc, EditorState>(
  //   'call addNote when call event SaveNote',
  //   setUp: () {
  //     editorBloc = EditorBloc();
  //   },
  //   build: () => editorBloc,
  //   act: (bloc) => bloc.add(SaveNote()),
  //   verify: (_) {
  //     verify(() => noteRepository.addNote('', '')).called(1);
  //   },
  // );

  // blocTest<EditorBloc, EditorState>(
  //   'emits status [loading,error] when NoteRepository.addNote has error',
  //   setUp: () {
  //     editorBloc = EditorBloc();
  //     when(() => noteRepository.addNote(any(), any())).thenThrow(Error());
  //   },
  //   build: () => editorBloc,
  //   act: (bloc) => bloc.add(SaveNote()),
  //   expect: () => <EditorState>[
  //     EditorState(status: Status.loading),
  //     EditorState(timeCreate: now, status: Status.loading),
  //     EditorState(timeCreate: now, status: Status.error),
  //   ],
  // );
}
