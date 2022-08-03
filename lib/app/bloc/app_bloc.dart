import 'dart:async';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
// import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart ' as auth;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

import '../../model/user.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required this.ggAuthenticationRepository}) : super(AppState()) {
    on<CheckLogin>(_onCheckLogin);

    on<AppLogoutRequested>(_onLogoutRequested);
  }

  final GoogleAuthenRepository ggAuthenticationRepository;

  void _onCheckLogin(
    CheckLogin event,
    Emitter<AppState> emit,
  ) async {
    final currentUser = await ggAuthenticationRepository.getUser();
    final statusApp = (currentUser == null)
        ? AppStatus.unauthenticated
        : AppStatus.authenticated;

    emit(state.copyWith(user: currentUser, status: statusApp));
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    await ggAuthenticationRepository.logOut();
    final box = await Hive.box<Note>('notes').clear();
  }
}
