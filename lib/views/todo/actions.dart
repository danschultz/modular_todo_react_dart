part of todo_demo.views.todo;

Action<State> beginEditing() {
  return (State todo) {
    return new State(todo.id, todo.title, todo.isComplete, true);
  };
}

Action<State> finishEditing(String title) {
  return (State todo) {
    return new State(todo.id, title, todo.isComplete, false);
  };
}

Action<State> toggleComplete(bool isComplete) {
  return (State todo) {
    return new State(todo.id, todo.title, isComplete, todo.isEditing);
  };
}
