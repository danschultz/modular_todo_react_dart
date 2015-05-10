part of unidirectional_demo.todo_list;

var todoListView = registerComponent(() => new TodoListView());

class TodoListView extends Component {
  TodoList get _state => props["state"];
  Channel<Action<TodoList>> get _actions => props["actions"];

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

  _renderTodos(Iterable<Todo> todos) {
    return todos.map((todo) => _renderTodo(todo));
  }

  _renderTodo(Todo todo) {
    var todoActions = new Channel<Action<Todo>>();
    todoActions.stream.listen((action) => _actions.add(updateTodo(todo.id, action)));

    var remove = new Channel();
    remove.stream.listen((action) => _actions.add(removeTodo(todo.id)));

    return li({}, todoView({"todo": todo, "actions": todoActions, "remove": remove}));
  }

  Iterable<Todo> _filterTodos(Iterable<Todo> todos, String filter) {
    return todos.where((todo) {
      return filter == TodoFilter.all
          || filter == TodoFilter.completed && todo.isComplete
          || filter == TodoFilter.active && !todo.isComplete;
    });
  }
}
