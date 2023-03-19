import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import '../widget/dialog.dart';
import '../widget/task_details.dart';
import '../widget/todo_widget.dart';

import '/model/todo_model.dart';
import '/viewmodel/db_viewmodel.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final _newTodoNameController = TextEditingController();

  void _saveTask(String desc, String url, String titleName) {
    final taskName = titleName;
    FirebaseFirestore.instance.collection('todos').add({
      "name": taskName,
      "url": url,
      "desc": desc,
      "date": DateTime.now(),
      "strike": false
    });
  }

  String newTodoName = "";

  @override
  void dispose() {
    _newTodoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddTaskPopUp();

                  Consumer<DatabaseViewModel>(
                    builder: (context, database, _) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              // padding: EdgeInsets.symmetric(
                              //   horizontal: size.width * 0.0225,
                              // ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    child: Text(
                                      'ToDo Task',
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _newTodoNameController,
                                    onChanged: (value) {
                                      setState(() {
                                        newTodoName = value;
                                        print(_newTodoNameController.text);
                                        print('newTodoName   $newTodoName  ');
                                      });
                                    },
                                    // validator: (value) {
                                    //   if (value == "" || value!.isEmpty) {
                                    //     return "Todo name required";
                                    //   }
                                    //
                                    //   if (value.length < 20) {
                                    //     return "The name should be meaningful";
                                    //   }
                                    //
                                    //   return null;
                                    // },
                                    decoration: InputDecoration(
                                      hintText: "Title name",
                                      filled: true,
                                      fillColor: kFillingColor,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.018,
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () async {
                                    var todos_id = await database.addData(
                                        context: context,
                                        isDone: false,
                                        todoName: newTodoName,
                                        entryTime: DateTime.now());

                                    setState(() {
                                      _newTodoNameController.clear();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: kElevatedButtonColor,
                                  ),
                                  child: const Text(
                                    "Submit",
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                });
          }),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('todo screen '),
            Text(
              'App ver. 2.0.0+2',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.height * 0.020,
          ),
          Consumer<DatabaseViewModel>(
            builder: (context, database, _) {
              return StreamBuilder<QuerySnapshot>(
                  stream: database.getTodos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('snapshot has error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          height: 200,
                          width: 300,
                          color: Colors.red,
                          child: const Center(
                            child: Text(
                              'NO TASK TO DO!',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }
                      // var todo;
                      // snapshot.data!.docs
                      //     .map((DocumentSnapshot document) {
                      //     todo = Todo.fromDocSnapshot(document);}
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (_, int index) {
                          Todo todo =
                              Todo.fromDocSnapshot(snapshot.data!.docs[index]);

                          return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (dir) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text("Are you sure?"),
                                    actions: [
                                      // ignore: deprecated_member_use
                                      TextButton(
                                        child: const Text("No Thanks"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                      // ignore: deprecated_member_use
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () async {
                                          print(
                                              'todo id equal to snap id ${todo.id == snapshot.data!.docs[index].id}');

                                          print('todo id   ${todo.id}');

                                          print(
                                              ' snap id ${snapshot.data!.docs[index].id}');
                                          database.deleteTodo(todo.id!);
                                          // FirebaseFirestore.instance
                                          //     .collection("todos")
                                          //     .doc(
                                          //         snapshot.data!.docs[index].id)
                                          //     .delete();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: TodoWidget(
                                todo: todo,
                              ));
                        },
                      );
                    }
                    return Container(
                      color: Colors.green,
                    );
                  });
            },
          ),
          SizedBox(
            height: size.height * 0.045,
          ),
        ],
      ),
    ));
  }
}

//
// FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
// future: database.getTodos(),
// builder: (context, snapshot) {
//   if (!snapshot.hasData) {
//     return const Center(
//       child: Text("No todos"),
//     );
//   }
//
//   return ListView(
//     padding: EdgeInsets.symmetric(
//       horizontal: size.width * 0.0225,
//     ),
//     children: snapshot.data!.docs.map(
//       (queryDocumentSnapshot) {
//         var todo = Todo.fromDocSnapshot(queryDocumentSnapshot);
//         return TodoWidget(
//           todoID: queryDocumentSnapshot.id,
//           todoName: todo.todoName,
//           isDone: todo.isDone,
//         );
//       },
//     ).toList(),
//   );

//   ListView(
//   padding: EdgeInsets.symmetric(
//     horizontal: size.width * 0.0225,
//   ),
//   children: snapshot.data!.docs.map(
//     (queryDocumentSnapshot) {
//       var todo = Todo.fromDocSnapshot(queryDocumentSnapshot);
//       return TodoWidget(
//         todoID: queryDocumentSnapshot.id,
//         todoName: todo.todoName,
//         isDone: todo.isDone,
//       );
//     },
//   ).toList(),
// );
