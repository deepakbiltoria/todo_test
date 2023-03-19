import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String todoName;
  bool isDone;

  final String? id;
  final String? todo_Uid;
  final Timestamp? entryTime;

  Todo({
    required this.entryTime,
    required this.todoName,
    required this.isDone,
    required this.id,
    required this.todo_Uid,
  });

  factory Todo.fromDocSnapshot(DocumentSnapshot document) {
    return Todo(
      todoName: document.get('title'),
      isDone: document.get('isDone'),
      id: document.id,
      todo_Uid: document.get('user_id'),
      entryTime: document.get('entryTime'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": todo_Uid,
      "title": todoName,
      "isDone": isDone,
      'entryTime': entryTime
    };
  }
}
