// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/widget/task_details.dart';

import '../model/todo_model.dart';

class TodoWidget extends StatefulWidget {
  Todo todo;
  TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    Todo _todo = widget.todo;
    return Card(
      elevation: 5,
      child: ListTile(
        dense: true,
        minLeadingWidth: 5,
        onTap: () {
          print('Tapped');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TaskDetails(
                    todo: _todo,
                  )));
        },
        title: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _todo.todoName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: _todo.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                trailing: Checkbox(
                  value: _todo.isDone, //strike
                  onChanged: (val) {
                    setState(() {
                      _todo.isDone = val!; //strike
                      FirebaseFirestore.instance
                          .collection("todos")
                          .doc(_todo.id)
                          .update({"isDone": _todo.isDone ? true : false});
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
