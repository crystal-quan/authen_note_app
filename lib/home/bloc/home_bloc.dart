import 'package:authen_note_app/model/note_model.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
 
    on<GetNote>(_onGetNote);
    on<Delete>(_onDelete);
  }
  FirebaseFirestore db = FirebaseFirestore.instance;
  final currentUser = fire_auth.FirebaseAuth.instance.currentUser;
  late List<QueryDocumentSnapshot<Note>> notes;

  void _onGetNote(GetNote event, Emitter<HomeState> emit) async {
    if (currentUser?.email != null) {
      final docRef = await db
          .collection("users")
          .doc(currentUser!.email)
          .collection('notes')
          .withConverter(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore(),
          )
          .get();

      notes = docRef.docs;
      List<Note> example = notes.map((e) {
       
        return e.data();
      }).toList();

      emit(state.copyWith(listNotes: example));
  
    }

    /// tương tự forEach
  }

  void _onDelete(Delete event, Emitter<HomeState> emit) async {
    await db
        .collection("users")
        .doc(currentUser!.email)
        .collection('notes')
        .doc(event.id)
        .delete();
  }
}
