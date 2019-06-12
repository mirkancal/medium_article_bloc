import 'dart:async';
import 'package:vanilla_bloc_todos/src/bloc/todo_event.dart';
import 'package:vanilla_bloc_todos/src/model/todo.dart';

class TodoBloc {
  List<Todo> _todos = [];

  final _todoStateController = StreamController<List<Todo>>();
  StreamSink<List<Todo>> get _inTodoSink => _todoStateController.sink;

  Stream<List<Todo>> get todos => _todoStateController.stream;

  final _todoEventController = StreamController<TodoEvent>();
  Sink<TodoEvent> get todoEventSink => _todoEventController.sink;

  TodoBloc() {
    _todoEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(TodoEvent event) {
    if (event is AddTodoEvent) {
      _todos.add(event.todo);
    } else if (event is DeleteTodoEvent) {
      _todos.removeAt(event.index);
    } else if (event is ToggleTodoEvent) {
      _todos.asMap().forEach((index, todo) {
        if (index == event.index) {
          todo.isCompleted = !todo.isCompleted;
        }
      });
    }

    _inTodoSink.add(_todos);
  }

  void dispatch(TodoEvent event) {
    todoEventSink.add(event);
  }

  void dispose() {
    _todoEventController.close();
    _todoStateController.close();
  }
}
