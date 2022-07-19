part of 'google_login_bloc.dart';



class GoogleLoginState extends Equatable {
  const GoogleLoginState({
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [status];

  GoogleLoginState copyWith({
    FormzStatus? status,
    String? errorMessage,
  }) {
    return GoogleLoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
