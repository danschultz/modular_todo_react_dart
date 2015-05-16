part of todo_demo.todo;

var todoView = registerComponent(() => new TodoView());

class TodoView extends Component {
  Todo get _todo => props["todo"];
  Channel<Action> get _actions => props["actions"];
  Channel get _remove => props["remove"];

  String get _editedText => state["editedText"];

  Channel _toggleComplete;
  Channel<SyntheticMouseEvent> _onTextClick;
  Channel<SyntheticKeyboardEvent> _onInput;
  Channel<SyntheticKeyboardEvent> _onKeyUp;

  void componentWillMount() {
    _toggleComplete = new Channel();
    _toggleComplete.stream.listen((_) => _actions.add(toggleComplete(!_todo.isComplete)));

    _onTextClick = new Channel();
    _onTextClick.stream.listen((_) {
      _actions.add(beginEditing());
      setState({"editedText": _todo.title});
    });

    _onInput = new Channel(sync: true);
    _onInput.stream.listen((event) => setState({"editedText": event.target.value}));

    _onKeyUp = new Channel();
    _onKeyUp.stream
        .where((event) => event.keyCode == 13) // Enter key
        .listen((event) => _actions.add(finishEditing(_editedText)));
  }

  render() {
    var classNames = ["todo"];

    if (_todo.isComplete) {
      classNames.add("is-complete");
    }

    return div({"className": classNames.join(" ")}, [
      _renderTitle(),
      button({"className": "todo--complete", "onClick": _toggleComplete}, "Complete"),
      button({"className": "todo--remove", "onClick": _remove}, "Remove")
    ]);
  }

  _renderTitle() {
    if (!_todo.isEditing) {
      return div({"className": "todo--title", "onClick": _onTextClick}, _todo.title);
    } else {
      return input({"className": "todo--edit-title", "onInput": _onInput, "onKeyUp": _onKeyUp, "value": _editedText});
    }
  }
}
