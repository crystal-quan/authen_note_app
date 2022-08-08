part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    this.listNotes,
    this.status,
    this.loginStatus = FormzStatus.pure,
    this.user
  });
  final User? user;
  final FormzStatus loginStatus;
  Status? status;
  final List<Note>? listNotes;
  HomeState copyWith(
      {List<Note>? listNotes, Status? status, FormzStatus? loginStatus, User? userCopy}) {
    return HomeState(
      listNotes: listNotes,
      status: status,
      loginStatus: loginStatus ?? this.loginStatus,
      user: userCopy,
    );
  }

  @override
  List<Object?> get props => [listNotes, status, loginStatus];
}
