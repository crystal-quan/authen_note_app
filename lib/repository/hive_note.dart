import 'package:hive/hive.dart';

part 'hive_note.g.dart';

@HiveType(typeId: 1)
class HiveNote {
  HiveNote(
      {required this.id,
      this.title,
      this.content,
      this.timeCreate,
      this.timeUpdate});
  @HiveField(0, defaultValue: '')
  String id;

  @HiveField(1, defaultValue: '')
  String? title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  String? timeCreate;

  @HiveField(4)
  String? timeUpdate;

  @HiveField(5)
  List<HiveNote>? listHiveNote;
}
