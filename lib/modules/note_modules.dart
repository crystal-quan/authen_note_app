

import 'package:cloud_firestore/cloud_firestore.dart';

class  Note {
   Note({
    this.content,
    this.timeCreate,
    this.title,
  });

  final String? title;
  final String? content;
  final String? timeCreate;

  factory Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Note(
      content: data?['content'],
      title: data?['title'],
      timeCreate: data?['timeCreate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "name": title,
      if (content != null) "state": content,
      if (timeCreate != null) "country": timeCreate,
    };
  }
}