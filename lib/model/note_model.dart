import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class Note extends Equatable {
  Note({
    this.id = '',
    this.content,
    this.timeCreate,
    this.title,
    this.timeUpdate,
    this.isDelete = false,
  });
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String? title;

  @HiveField(3)
  final String? content;

  @HiveField(4)
  final DateTime? timeCreate;

  @HiveField(5)
  DateTime? timeUpdate;

  @HiveField(6)
  bool? isDelete;

  factory Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Note(
        id: data?['note id'],
        content: data?['content'],
        title: data?['title'],
        timeCreate: data?['timeCreate'],
        timeUpdate: data?['timeUpdate'],
        isDelete: data?['isDelete']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'note id': id,
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (timeCreate != null) "timeCreate": timeCreate,
      if (timeUpdate != null) "timeUpdate": timeUpdate,
      if (isDelete != null) "isDelete": isDelete,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, timeCreate, content, title, isDelete];
}
