import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockFirebaseAuth auth;
  late Note mockNote;
  late NoteRepository noteRepository;
  late FakeFirebaseFirestore firestore;

  late MockNoteRepository mockNoteRepository;
  final Note note = Note(
      id: 'randomId',
      content: 'mockContent',
      timeCreate: 'MockTime',
      title: 'MockTitle',
      timeUpdate: 'NewTime');

  late HomeBloc homeBloc;
  late List<Note> listNotes;
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
      auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      firestore = FakeFirebaseFirestore();
      mockNoteRepository = MockNoteRepository();
      homeBloc = HomeBloc(noteRepository: mockNoteRepository);
      listNotes = <Note>[note];
      when(() => mockNoteRepository.getNote())
          .thenAnswer((invocation) => Future.value(listNotes));
      when(() => mockNoteRepository.box)
          .thenReturn(await Hive.openBox<HiveNote>('notes-testing'));
      when(() => mockNoteRepository.firestore).thenReturn(firestore);
      when(() => mockNoteRepository.firebaseAuth).thenReturn(auth);
    },
  );

  test('initial state.listNote is null', () {
    expect(homeBloc.state.listNotes, isNull);
  });

  blocTest(
    'emit nothing when NoteRepo is null',
    build: () => HomeBloc(noteRepository: null),
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
}
