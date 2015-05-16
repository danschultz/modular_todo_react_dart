part of todo_demo.views.todo_list;

Action<State> createTodo(String title) {
  return (State state) {
    var newTodo = new todo.State(state.nextId, title, false, false);
    var todos = state.todos.toList()..insert(0, newTodo);
    return new State(todos, state.nextId + 1, state.filter);
  };
}

Action<State> removeTodo(int id) {
  return (State state) {
    var todos = state.todos.toList()..removeWhere((todo) => todo.id == id);
    return new State(todos, state.nextId, state.filter);
  };
}

Action<State> updateTodo(int id, Action<todo.State> action) {
  return (State state) {
    var todos = state.todos.map((todo) => todo.id == id ? action(todo) : todo);
    return new State(todos, state.nextId, state.filter);
  };
}

Action<State> filterTodos(String filter) {
  return (State state) {
    return new State(state.todos, state.nextId, filter);
  };
}
