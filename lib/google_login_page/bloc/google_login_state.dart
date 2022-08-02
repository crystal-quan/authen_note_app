part of 'google_login_bloc.dart';

class GoogleLoginState extends Equatable {
   const GoogleLoginState({
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.noteOffline,
  });

  final FormzStatus status;
  final String? errorMessage;
  final List<Note>? noteOffline;
  @override
  List<Object> get props => [status];

  GoogleLoginState copyWith({
    FormzStatus? status,
    String? errorMessage,
    List<Note>? noteOffline,
  }) {
    return GoogleLoginState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        noteOffline: noteOffline );
  }
}
