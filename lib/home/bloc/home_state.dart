part of 'home_bloc.dart';



class HomeState extends Equatable {
  HomeState({this.listNotes, this.status});
  Status? status;
  final List<Note>? listNotes;
  HomeState copyWith({List<Note>? listNotes, Status? status}) {
    return HomeState(listNotes: listNotes, status: status);
  }

  @override
  List<Object?> get props => [listNotes, status];
}
