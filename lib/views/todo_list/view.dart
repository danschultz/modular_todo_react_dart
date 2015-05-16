part of todo_demo.views.todo_list;

var view = registerComponent(() => new TodoListView());

class TodoListView extends Component {
  State get _state => props["state"];
  Channel<Action<State>> get _actions => props["actions"];

  String get _newTodoText => state["newTodoText"];

  Channel<SyntheticKeyboardEvent> _onInput;
  Channel<SyntheticKeyboardEvent> _onKeyUp;

  Channel<SyntheticMouseEvent> _onShowAllClick;
  Channel<SyntheticMouseEvent> _onShowActiveClick;
  Channel<SyntheticMouseEvent> _onShowCompletedClick;

  void componentWillMount() {
    _onInput = new Channel(sync: true);
    _onInput.stream.listen((event) => setState({"newTodoText": event.target.value}));

    _onKeyUp = new Channel();
    _onKeyUp.stream
        .where((event) => event.keyCode == 13) // Entry key
        .doAction((_) => _actions.add(createTodo(_newTodoText)))
        .listen((_) => setState({"newTodoText": ""}));

    _onShowAllClick = new Channel(sync: true);
    _onShowActiveClick = new Channel(sync: true);
    _onShowCompletedClick = new Channel(sync: true);

    var showAll = _onShowAllClick.stream
        .doAction((event) => event.preventDefault())
        .map((_) => TodoFilter.all);

    var showActive = _onShowActiveClick.stream
        .doAction((event) => event.preventDefault())
        .map((_) => TodoFilter.active);

    var showCompleted = _onShowCompletedClick.stream
        .doAction((event) => event.preventDefault())
        .map((_) => TodoFilter.completed);

    showAll
        .merge(showActive)
        .merge(showCompleted)
        .listen((filter) => _actions.add(filterTodos(filter)));
  }

  render() {
    var todos = _filterTodos(_state.todos, _state.filter);
    var active = _filterTodos(todos, TodoFilter.active);

    return div({}, [
      input({"onInput": _onInput, "onKeyUp": _onKeyUp, "value": _newTodoText, "placeholder": "Add Task"}),
      div({}, [
        span({}, "${active.length} items left"),
        div({}, [a({"href": "#all", "onClick": _onShowAllClick}, "All")]),
        div({}, [a({"href": "#active", "onClick": _onShowActiveClick}, "Active")]),
        div({}, [a({"href": "#completed", "onClick": _onShowCompletedClick}, "Completed")])
      ]),
      ul({}, _renderTodos(todos))
    ]);
  }

  _renderTodos(Iterable<todo.State> todos) {
    return todos.map((todo) => _renderTodo(todo));
  }

  _renderTodo(todo.State state) {
    var todoActions = new Channel<Action<todo.State>>();
    todoActions.stream.listen((action) => _actions.add(updateTodo(state.id, action)));

    var remove = new Channel();
    remove.stream.listen((action) => _actions.add(removeTodo(state.id)));

    return li({}, todo.view({"state": state, "actions": todoActions, "remove": remove}));
  }

  Iterable<todo.State> _filterTodos(Iterable<todo.State> todos, String filter) {
    return todos.where((todo) {
      return filter == TodoFilter.all
          || filter == TodoFilter.completed && todo.isComplete
          || filter == TodoFilter.active && !todo.isComplete;
    });
  }
}
