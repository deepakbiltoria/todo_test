// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return ListTile(
      dense: true,
      minLeadingWidth: 5,
      onTap: () {},
      title: Row(
        children: [
          Expanded(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todo.todoName,
                      style: TextStyle(
                          decoration:
                              _todo.isDone ? TextDecoration.lineThrough : null,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
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
        ],
      ),
    );
  }
}
