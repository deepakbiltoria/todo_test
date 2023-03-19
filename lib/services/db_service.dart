import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/todo_model.dart';

class DatabaseService {
  CollectionReference todosCollectionReference =
      FirebaseFirestore.instance.collection('todos');

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> addTodo(
    BuildContext context,
    String todoName,
    bool isDone,
    String? id,
    DateTime entryTime,
  ) async {
    var todo_Uid = const Uuid().v4();

    Todo todo = Todo(
        todoName: todoName,
        id: id,
        isDone: isDone,
        todo_Uid: todo_Uid,
        entryTime: Timestamp.fromDate(entryTime));
    String todos_Id = await todosCollectionReference
        .add(todo.toMap())
        .then((value) => value.id);
    return todos_Id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getToDos() {
    return _firebaseFirestore
        .collection("todos")
        .orderBy('entryTime', descending: true)
        .snapshots();
  }

  Future<void> deleteTodo(String todoID) async {
    await _firebaseFirestore.collection("todos").doc(todoID).delete();
  }
}
