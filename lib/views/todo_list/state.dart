part of todo_demo.views.todo_list;

class State {
  final Iterable<todo.State> todos;
  final int nextId;
  final String filter;

  State(this.todos, this.nextId, this.filter);

  factory State.initial() {
    return new State([], 0, TodoFilter.all);
  }

  factory State.fromJson(Map json) {
    return new State(
        json["todos"].map((json) => new todo.State.fromJson(json)),
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
