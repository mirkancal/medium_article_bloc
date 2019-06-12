import 'package:flutter/material.dart';
import 'package:vanilla_bloc_todos/src/bloc/todo_bloc.dart';
import 'package:vanilla_bloc_todos/src/bloc/todo_event.dart';
import 'package:vanilla_bloc_todos/src/model/todo.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _bloc = TodoBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showDialog(context, _bloc);
          }),
      body: StreamBuilder(
        stream: _bloc.todos,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text('Add new todo'),
            );
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onDoubleTap: () =>
                    _bloc.dispatch(ToggleTodoEvent(index: index)),
                onLongPress: () =>
                    _bloc.dispatch(DeleteTodoEvent(index: index)),
                child: ListTile(
                    title: Text(
                  snapshot.data[index].title,
                  style: TextStyle(
                      decoration: snapshot.data[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )),
              );
            },
          );
        },
      ),
    );
  }
}

_showDialog(BuildContext context, TodoBloc bloc) async {
  TextEditingController _controller = TextEditingController();
  await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'What to do?', hintText: 'eg. Go to mall'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  if (_controller.text != '') {
                    bloc.todoEventSink.add(
                      AddTodoEvent(
                        todo: Todo(title: '${_controller.text.toString()}'),
                      ),
                    );
                  }
                  Navigator.pop(context);
                })
          ],
        );
      });
}
