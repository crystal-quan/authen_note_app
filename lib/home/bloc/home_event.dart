// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetNote extends HomeEvent {}

// class GetOffline extends HomeEvent {}

class Delete extends HomeEvent {
  String id;
  String? title;
  String? content;
  DateTime? timeCreate;

  Delete({required this.id, this.title, this.content, this.timeCreate});
  @override
  List<Object> get props => [id];
}

class LoginWithGoogle extends HomeEvent {}

class AppLogoutRequested extends HomeEvent {}

class CheckLogin extends HomeEvent {}

class AddNote extends HomeEvent {
  String? title;
  String? content;

  AddNote({this.title, this.content});
}

class UpdateNote extends HomeEvent {
  String id;
  String title;
  String content;
  DateTime? timeCreate;

  UpdateNote({
    required this.id,
    required this.title,
    required this.content,
    this.timeCreate,
  });
  @override
  List<Object> get props => [id];
}
