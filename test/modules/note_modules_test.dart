import 'package:authen_note_app/modules/note_modules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Note', () {
    const id = 'mock-id';
    const title = 'mock-title';
    const content = 'mock-content';
    const timeCreate = 'mock-timeCreate';

    test('Note create', () {
      expect(
        Note(title: title, content: content, timeCreate: timeCreate, id: id),
        equals(Note(
            title: title, content: content, timeCreate: timeCreate, id: id)),
      );
    });

    test('isEmpty returns true for empty Note id', () {
      final note = Note(id: '');

      expect(note.id?.isEmpty, isTrue);
      expect(note.content?.isEmpty, null);
      expect(note.title?.isEmpty, null);
      expect(note.timeCreate?.isEmpty, null);
    });

    test('isEmpty returns false for non-empty user', () {
      final note =
          Note(title: title, content: content, timeCreate: timeCreate, id: id);
      expect(note.id?.isEmpty, isFalse);
      expect(note.title?.isEmpty, isFalse);
      expect(note.timeCreate?.isEmpty, isFalse);
      expect(note.content?.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty Note ', () {
      final note = Note(id: '');
      expect(note.id?.isNotEmpty, isFalse);
      expect(note.content?.isNotEmpty, isNull);
      expect(note.title?.isNotEmpty, isNull);
      expect(note.timeCreate?.isNotEmpty, isNull);
    });

    test('isNotEmpty returns true for non-empty Note', () {
      final note =
          Note(title: title, content: content, timeCreate: timeCreate, id: id);
      expect(note.id?.isNotEmpty, isTrue);
      expect(note.content?.isNotEmpty, isTrue);
      expect(note.title?.isNotEmpty, isTrue);
      expect(note.timeCreate?.isNotEmpty, isTrue);
    });
  });
}
