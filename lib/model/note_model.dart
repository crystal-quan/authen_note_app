import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Note extends Equatable {
   Note({
    this.id = '',
    this.content,
    this.timeCreate,
    this.title,
    this.timeUpdate
  });

  final String id;
  final String? title;
  final String? content;
  final String? timeCreate;
  String? timeUpdate;

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
      timeUpdate:data?['timeUpdate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) 'Null id': id,
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (timeCreate != null) "timeCreate": timeCreate,
      if (timeUpdate != null) "timeUpdate": timeUpdate,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, timeCreate, content, title];
}
