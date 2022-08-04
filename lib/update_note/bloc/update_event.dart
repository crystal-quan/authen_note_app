// ignore_for_file: must_be_immutable

part of 'update_bloc.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class EditTitle extends UpdateEvent {
  String? value;
  String defaulValue;
  EditTitle(this.value, this.defaulValue);
}

class EditContent extends UpdateEvent {
  String? value;
  String defaulValue;
  EditContent(this.value, this.defaulValue);
}

class ClickUpdate extends UpdateEvent {
  String id;
  DateTime? timeCreate;
  ClickUpdate({required this.id,this.timeCreate});
}
