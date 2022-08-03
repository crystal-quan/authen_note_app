part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  AppState({this.user = User.empty, this.status = AppStatus.unauthenticated});

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  AppState copyWith({
    AppStatus? status,
    User? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
