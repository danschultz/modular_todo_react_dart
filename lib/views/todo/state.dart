part of todo_demo.views.todo;

class State {
  final int id;
  final String title;
  final bool isComplete;
  final bool isEditing;

  State(this.id, this.title, this.isComplete, this.isEditing);

  factory State.fromJson(Map json) {
    return new State(json["id"], json["title"], json["isComplete"], json["isEditing"]);
  }

  Map toJson() => {
    "id": id,
    "title": title,
    "isComplete": isComplete,
    "isEditing": isEditing
  };
}
