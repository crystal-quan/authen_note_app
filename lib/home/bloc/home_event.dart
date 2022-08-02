// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetNote extends HomeEvent {}

class AutoAsync extends HomeEvent{}


class Delete extends HomeEvent {
   String id;
   String? title;
   String? content;
   DateTime? timeCreate;


  Delete({required this.id,this.title,this.content,this.timeCreate});
  @override
  List<Object> get props => [id];
}
