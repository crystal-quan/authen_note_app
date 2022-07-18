import 'package:authen_note_app/edit_page/bloc/editor_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'update_event.dart';
part 'update_state.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(UpdateState()) {
    // on<UpdateEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<EditTitle>(_onEditTitle);
    on<EditContent>(_onEditContent);
    on<ClickUpdate>(_onClickUpdate);
  }

  void _onEditTitle(EditTitle event, Emitter<UpdateState> emit) {
    emit(state.copywith(title: event.value));
  }

  void _onEditContent(EditContent event, Emitter<UpdateState> emit) {
    emit(state.copywith(content: event.value));
  }

  void _onClickUpdate(ClickUpdate event, Emitter<UpdateState> emit) {
    final now = DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();
    emit(state.copywith(timeUpdate: '$day-$month-$year'));

    final currentUser = FirebaseAuth.instance.currentUser;

    final db = FirebaseFirestore.instance;
    if (currentUser?.email != null) {
      db
          .collection('users')
          .doc(currentUser!.email)
          .collection('notes')
          .doc(event.id)
          .update({
        'time update': state.timeUpdate,
        'title': state.title,
        'content': state.content,
      });
    }
  }
}
