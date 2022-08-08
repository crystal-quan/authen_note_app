import 'dart:async';
import 'dart:developer';

import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
import 'package:authen_note_app/repository/note_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  GoogleLoginBloc(
      {required this.authenticationRepository, required this.noteRepo})
      : super(const GoogleLoginState()) {
    on<LoginWithGoogle>(logInWithGoogle);
    on<GetNoteOffline>(_onGetNoteOffline);
  }

  final GoogleAuthenRepository authenticationRepository;
  late NoteRepository noteRepo;

  Future<void> logInWithGoogle(
      GoogleLoginEvent event, Emitter<GoogleLoginState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
        ),
      );
    }
  }

  Future<void> _onGetNoteOffline(
      GetNoteOffline event, Emitter<GoogleLoginState> emit) async {
    late List<Note>? result;
    try {
      final noteOffline = await noteRepo.getNote();
      print('quanquan - $noteOffline');
      if (noteOffline != null) {
        result = noteOffline
            .where(
              (element) => element.isDelete == false,
            )
            .toList();
      } else {
        result = null;
      }
    } catch (e, stack) {
      log(e.toString(), error: e, stackTrace: stack);
      throw Error();
    }

    emit(state.copyWith(noteOffline: result));
  }
}
