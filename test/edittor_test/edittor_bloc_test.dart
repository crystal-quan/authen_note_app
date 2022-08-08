import 'package:authen_note_app/edit_page/bloc/editor_bloc.dart';
import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/status.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late EditorBloc editorBloc;
  late MockNoteRepository noteRepository;
  late DateTime now;

  setUp(
    () {
      now = DateTime.now();
      noteRepository = MockNoteRepository();
      // editorBloc = EditorBloc(noteRepository: noteRepository);
    },
  );

  test(
    'initial state is EditorState',
    () {
      editorBloc = EditorBloc();
      expect(editorBloc.state, EditorState());
    },
  );

  blocTest<EditorBloc, EditorState>(
    'Edit Title',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle('title')),
    expect: () => <EditorState>[EditorState(title: 'title')],
  );

  blocTest<EditorBloc, EditorState>(
    'Edit Content',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle('Content')),
    expect: () => <EditorState>[EditorState(title: 'Content')],
  );
  blocTest<EditorBloc, EditorState>(
    'call addNote when call event SaveNote',
    setUp: () {
      editorBloc = EditorBloc();
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    verify: (_) {
      verify(() => noteRepository.addNote('', '')).called(1);
    },
  );

  blocTest<EditorBloc, EditorState>(
    'emits status [loading,error] when NoteRepository.addNote has error',
    setUp: () {
      editorBloc = EditorBloc();
      when(() => noteRepository.addNote(any(), any()))
          .thenThrow(Error());
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    expect: () => <EditorState>[
      EditorState(status: Status.loading),
      EditorState(timeCreate: now, status: Status.loading),
      EditorState(timeCreate: now, status: Status.error),
    ],
  );

  
