part of todo_demo.todo_list;

Action<TodoList> createTodo(String title) {
  return (TodoList state) {
    var todo = new Todo(state.nextId, title, false, false);
    var todos = state.todos.toList()..insert(0, todo);
    return new TodoList(todos, state.nextId + 1, state.filter);
  };
}

Action<TodoList> removeTodo(int id) {
  return (TodoList state) {
    var todos = state.todos.toList()..removeWhere((todo) => todo.id == id);
    return new TodoList(todos, state.nextId, state.filter);
  };
}

Action<TodoList> updateTodo(int id, Action<Todo> action) {
  return (TodoList state) {
    var todos = state.todos.map((todo) => todo.id == id ? action(todo) : todo);
    return new TodoList(todos, state.nextId, state.filter);
  };
}

Action<TodoList> filterTodos(String filter) {
  return (TodoList state) {
    return new TodoList(state.todos, state.nextId, filter);
  };
}
