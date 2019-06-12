import 'package:meta/meta.dart';

class Todo {
  Todo({@required this.title, this.isCompleted = false});
  String title;
  bool isCompleted;
}
