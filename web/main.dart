import 'dart:convert';
import 'dart:html';
import 'package:frappe/frappe.dart';
import 'package:logging/logging.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' as react_client;
import 'package:todo_demo/framework.dart';
import 'package:todo_demo/views/todo_list.dart' as todo_list;

void main() {
  react_client.setClientConfiguration();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) => print(record.toString()));

  var applicationElement = querySelector("#application");
  var actions = new Channel<Action<todo_list.State>>.broadcast();
  var initialState = window.localStorage.containsKey("todo-demo")
      ? new todo_list.State.fromJson(JSON.decode(window.localStorage["todo-demo"]))
      : new todo_list.State.initial();

  var historyState = new EventStream(window.onPopState)
      .map((event) => JSON.decode(event.state))
      .map((json) => new todo_list.State.fromJson(json))
      .doAction((state) => _logger.info("Popped #${state.filter} off history"));
  var appState = actions.stream.scan(initialState, (state, action) => action(state));

  appState.merge(historyState).listen((state) {
    react.render(todo_list.view({"actions": actions, "state": state}), applicationElement);
  });

  appState
      .distinct((previous, next) => previous.filter == next.filter)
      .doAction((state) => _logger.info("Pushing #${state.filter} onto history"))
      .listen((state) => window.history.pushState(JSON.encode(state), "TodoMVC", "#${state.filter}"));

  appState
      .map((state) => JSON.encode(state))
      .doAction((state) => _logger.finest("Writing state to local storage"))
      .listen((json) => window.localStorage["todo-demo"] = json);
}

final _logger = new Logger("main");
