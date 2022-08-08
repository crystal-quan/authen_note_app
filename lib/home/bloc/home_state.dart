part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState(
      {this.listNotes,
      this.status = Status.loading,
      this.loginStatus = FormzStatus.pure,
      this.user = User.empty});
  final User user;
  final FormzStatus loginStatus;
  Status? status;
  final List<Note>? listNotes;
  HomeState copyWith(
      {List<Note>? listNotes,
      Status? status,
      FormzStatus? loginStatus,
      User? user}) {
    return HomeState(
      listNotes: listNotes ?? this.listNotes,
      status: status ?? this.status,
      loginStatus: loginStatus ?? this.loginStatus,
      user: user ?? this.user,
    );
  }



  @override
  List<Object?> get props => [listNotes, status, loginStatus, user];
}
