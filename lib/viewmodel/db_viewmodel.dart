import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/model/todo_model.dart';
import '/services/db_service.dart';

class DatabaseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  Future<String> addData(
      {required BuildContext context,
      required String todoName,
      required bool isDone,
      String? id,
      required DateTime entryTime}) async {
    var todos_id = await _databaseService.addTodo(
        context, todoName, isDone, id, entryTime);
    notifyListeners();

    return todos_id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTodos() {
    return _databaseService.getToDos();
  }

  void deleteTodo(String todoID) async {
    await _databaseService.deleteTodo(todoID);
  }
}
