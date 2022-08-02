import 'dart:async';

import 'package:authen_note_app/home/bloc/home_bloc.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  GoogleLoginBloc(
      {required this.authenticationRepository, required this.noteRepo})
      : super(GoogleLoginState(noteOffline: [])) {
    on<LoginWithGoogle>(logInWithGoogle);
    on<GetNoteOffline>(_onGetNoteOffline);
  }

  final AuthenticationRepository authenticationRepository;
  final NoteRepository noteRepo;

  Future<void> logInWithGoogle(
      GoogleLoginEvent event, Emitter<GoogleLoginState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  FutureOr<void> _onGetNoteOffline(
      GetNoteOffline event, Emitter<GoogleLoginState> emit) async {
    final noteOffline = await noteRepo.getNote();
    final result = noteOffline
        ?.where(
          (element) => element.isDelete == false,
        )
        .toList();
    emit(state.copyWith(noteOffline: result));
  }
}
