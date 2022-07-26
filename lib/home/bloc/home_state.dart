part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.listNotes});
  final List<Note>? listNotes;
  HomeState copyWith({List<Note>? listNotes}) {
    return HomeState(listNotes: listNotes);
  }

  @override
  List<Object?> get props => [listNotes];
}
