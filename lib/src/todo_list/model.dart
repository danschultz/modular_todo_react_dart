part of unidirectional_demo.todo_list;

class TodoList {
  final Iterable<Todo> todos;
  final int nextId;
  final String filter;

  TodoList(this.todos, this.nextId, this.filter);

  factory TodoList.initial() {
    return new TodoList([], 0, TodoFilter.all);
  }

  factory TodoList.fromJson(Map json) {
    return new TodoList(
        json["todos"].map((json) => new Todo.fromJson(json)),
        json["nextId"],
        json["filter"]);
  }

  Map toJson() => {
    "todos": todos.toList(growable: false),
    "nextId": nextId,
    "filter": filter
  };
}

class TodoFilter {
  static const all = "all";
  static const active = "active";
  static const completed = "completed";
}