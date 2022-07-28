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
  late String time;

  setUp(
    () {
      now = DateTime.now();
      String day = now.day.toString();
      String month = now.month.toString();
      String year = now.year.toString();
      time = '$day-$month-$year';

      noteRepository = MockNoteRepository();
      // editorBloc = EditorBloc(noteRepository: noteRepository);
    },
  );

  test(
    'initial state is correct',
    () {
      editorBloc = EditorBloc(noteRepository: noteRepository);
      expect(editorBloc.state, EditorState());
    },
  );
  blocTest<EditorBloc, EditorState>(
    'call getTime and addNote when call SaveNote',
    setUp: () {
      editorBloc = EditorBloc(noteRepository: noteRepository);
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    verify: (_) {
      verify(() => noteRepository.addNote('', '', time)).called(1);
    },
  );

  blocTest<EditorBloc, EditorState>(
    'emits time is error when bloc.getTime has error',
    setUp: () {
      editorBloc = EditorBloc(noteRepository: noteRepository);
      when(() => editorBloc.getTime()).thenThrow(Error());
      // when(() => noteRepository.addNote(any(), any(), any()))
      //     .thenAnswer((invocation) => Future.value(Note(id: '')));
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    expect: () => <EditorState>[
      EditorState(status: Status.loading),
      EditorState(timeCreate: 'getTime error', status: Status.loading),
      EditorState(timeCreate: 'getTime error', status: Status.success),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'emits status [loading,error] when NoteRepository.addNote has error',
    setUp: () {
      editorBloc = EditorBloc(noteRepository: noteRepository);
      when(() => noteRepository.addNote(any(), any(), any()))
          .thenThrow(Error());
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    expect: () => <EditorState>[
      EditorState(status: Status.loading),
      EditorState(timeCreate: time, status: Status.loading),
      EditorState(timeCreate: time, status: Status.error),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'emit [loading , success] when saveNote',
    setUp: () {
      editorBloc = EditorBloc(noteRepository: noteRepository);
      when(() => noteRepository.addNote('', '', time)).thenAnswer(
          (invocation) async => await Future.value(Note(
              content: 'newContent',
              title: 'newTitile',
              timeCreate: 'newTime')));
    },
    build: () => editorBloc,
    act: (bloc) => bloc.add(SaveNote()),
    expect: () => <EditorState>[
      EditorState(status: Status.loading),
      EditorState(status: Status.loading, timeCreate: time),
      EditorState(
          timeCreate: time, status: Status.success, content: '', title: '')
    ],
  );
}
