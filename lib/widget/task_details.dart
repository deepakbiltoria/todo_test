import 'package:flutter/material.dart';

import '../model/todo_model.dart';
import '../utils/utils.dart';

class TaskDetails extends StatelessWidget {
  final Todo todo;
  TaskDetails({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        todo.todoName,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            todo.entry! ?? '',
                            style: const TextStyle(
                                color: Color(0xff0395eb),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            kFormatDateFromTimeStamp(todo.entryTime) ?? '',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Container(
                          child: Image.network(
                        todo.photoUrls!,
                        fit: BoxFit.cover,
                      )),
                    )
                  ],
                ))));
  }
}
