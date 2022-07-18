// ignore_for_file: must_be_immutable

part of 'update_bloc.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class EditTitle extends UpdateEvent {
  String? value;
  EditTitle(this.value);
}

class EditContent extends UpdateEvent {
  String? value;
  EditContent(this.value);
}

class ClickUpdate extends UpdateEvent {
  String? id;
  ClickUpdate({this.id});
}
