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
    'Edit Title return my_title',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle('my_title')),
    expect: () => <EditorState>[EditorState(title: 'my_title')],
  );

  blocTest<EditorBloc, EditorState>(
    'Edit Title return not null',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle(null)),
    expect: () => <EditorState>[EditorState(title: '')],
  );

  blocTest<EditorBloc, EditorState>(
    'Edit Content return my_Content',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle('my_Content')),
    expect: () => <EditorState>[EditorState(title: 'my_Content')],
  );
  blocTest<EditorBloc, EditorState>(
    'Edit Content return not null',
    build: () => EditorBloc(),
    act: (bloc) => bloc.add(EditorTitle(null)),
    expect: () => <EditorState>[EditorState(title: '')],
  );

  
}
