import 'package:authen_note_app/modules/note_modules.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetNote>(_onGetNote);
  }

  void _onGetNote(GetNote event, Emitter<HomeState> emit) async {
    final currentUser = fire_auth.FirebaseAuth.instance.currentUser;
    late List<QueryDocumentSnapshot<Note>> notes;
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (currentUser != null) {
      final docRef = await db
          .collection("users")
          .doc(currentUser.email)
          .collection('notes')
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .snapshots()
          .listen(
        (event) async {
          print("current data: ${event.docs.length}");
          notes = event.docs;
          List<Note> example = notes.map((e) {
            print('quanbv-${notes.length}');
            return e.data();
          }).toList();
          emit(state.copyWith(listNotes: example));
          print(state.listNotes!.length);
        },
      );

      // List<QueryDocumentSnapshot<Note>> notes =
      //     docRef as List<QueryDocumentSnapshot<Note>>;

      /// tương tự forEach

    } else {
      emit(state.copyWith());
    }
  }
}
