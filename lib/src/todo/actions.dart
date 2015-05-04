part of unidirectional_demo.todo;

Action<Todo> beginEditing() {
  return (Todo todo) {
    return new Todo(todo.id, todo.title, todo.isComplete, true);
  };
}

Action<Todo> finishEditing(String title) {
  return (Todo todo) {
    return new Todo(todo.id, title, todo.isComplete, false);
  };
}

Action<Todo> toggleComplete(bool isComplete) {
  return (Todo todo) {
    return new Todo(todo.id, todo.title, isComplete, todo.isEditing);
  };
}
