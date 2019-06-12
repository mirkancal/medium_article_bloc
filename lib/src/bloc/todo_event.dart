import 'package:vanilla_bloc_todos/src/model/todo.dart';

abstract class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  Todo todo;
  AddTodoEvent({this.todo});
}

class DeleteTodoEvent extends TodoEvent {
  int index;
  DeleteTodoEvent({this.index});
}

class ToggleTodoEvent extends TodoEvent {
  int index;
  ToggleTodoEvent({this.index});
}
