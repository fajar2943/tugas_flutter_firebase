import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tugas_firebase/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  // final _firestore = FirebaseFirestore.instance;
  final collectionTodos = FirebaseFirestore.instance.collection('Todos');
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _deskripsiCtrl = TextEditingController();
  TextEditingController _searchCtrl = TextEditingController();
  List<Todo> todoList = [];

  // final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    try {
      QuerySnapshot querySnapshot = await collectionTodos.get();
      setState(() {
        todoList.clear();
        for (var documents in querySnapshot.docs) {
          todoList.add(Todo(
            title: documents['title'],
            description: documents['description'],
            done: documents['done'],
            docId: documents['docId'],
          ));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void addItem() async {
    // todoList.add(Todo(_nameCtrl.text, _deskripsiCtrl.text));
    // await dbHelper.addTodo(Todo(_nameCtrl.text, _deskripsiCtrl.text));
    try {
      final id = collectionTodos.doc().id;
      collectionTodos.doc(id).set({
        'title': _nameCtrl.text,
        'description': _deskripsiCtrl.text,
        'done': false,
        'docId': id,
      });
    } catch (e) {
      print(e);
    }
    refreshList();
    _nameCtrl.text = '';
    _deskripsiCtrl.text = '';
  }

  void updateItem(String id, bool done) async {
    collectionTodos.doc(id).update({'done': done});
    refreshList();
  }

  void deleteItem(String id) async {
    collectionTodos.doc(id).delete();
    refreshList();
  }

  void tampilForm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(20),
              title: Text("Tambah Todo"),
              content: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(hintText: "Nama todo"),
                    ),
                    TextField(
                      controller: _deskripsiCtrl,
                      decoration:
                          InputDecoration(hintText: "Deskripsi pekerjaan"),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tutup")),
                ElevatedButton(
                    onPressed: () {
                      addItem();
                      Navigator.pop(context);
                    },
                    child: Text("Tambah")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Todo List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tampilForm();
        },
        child: Icon(Icons.add_box),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: todoList[index].done
                      ? IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            updateItem(
                                todoList[index].docId, !todoList[index].done);
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.radio_button_unchecked),
                          onPressed: () {
                            updateItem(
                                todoList[index].docId, !todoList[index].done);
                          },
                        ),
                  title: Text(todoList[index].title),
                  subtitle: Text(todoList[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItem(todoList[index].docId);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
