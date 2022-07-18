// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetNote extends HomeEvent {}


class Delete extends HomeEvent {
  String id;
  Delete({required this.id});
  @override
  List<Object> get props => [id];
}
