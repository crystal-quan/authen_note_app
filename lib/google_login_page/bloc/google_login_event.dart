part of 'google_login_bloc.dart';

abstract class GoogleLoginEvent extends Equatable {
  const GoogleLoginEvent();

  @override
  List<Object> get props => [];
}


class LoginWithGoogle extends GoogleLoginEvent{}