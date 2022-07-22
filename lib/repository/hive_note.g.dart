// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNoteAdapter extends TypeAdapter<HiveNote> {
  @override
  final int typeId = 1;

  @override
  HiveNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNote(
      id: fields[0] == null ? '' : fields[0] as String,
      title: fields[1] == null ? '' : fields[1] as String?,
      content: fields[2] as String?,
      timeCreate: fields[3] as String?,
      timeUpdate: fields[4] as String?,
    )..listHiveNote = (fields[5] as List?)?.cast<HiveNote>();
  }

  @override
  void write(BinaryWriter writer, HiveNote obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.timeCreate)
      ..writeByte(4)
      ..write(obj.timeUpdate)
      ..writeByte(5)
      ..write(obj.listHiveNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
