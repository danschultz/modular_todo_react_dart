part of unidirectional_demo.todo;

class Todo {
  final int id;
  final String title;
  final bool isComplete;
  final bool isEditing;

  Todo(this.id, this.title, this.isComplete, this.isEditing);

  factory Todo.fromJson(Map json) {
    return new Todo(json["id"], json["title"], json["isComplete"], json["isEditing"]);
  }

  Map toJson() => {
    "id": id,
    "title": title,
    "isComplete": isComplete,
    "isEditing": isEditing
  };
}