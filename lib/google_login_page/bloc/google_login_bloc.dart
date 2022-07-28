import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  GoogleLoginBloc({required this.authenticationRepository})
      : super(const GoogleLoginState()) {
    on<LoginWithGoogle>(logInWithGoogle);
  }

  final AuthenticationRepository authenticationRepository;

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
}
