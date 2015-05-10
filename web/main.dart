import 'dart:convert';
import 'dart:html';
import 'package:frappe/frappe.dart';
import 'package:logging/logging.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' as react_client;
import 'package:unidirectional_demo/framework.dart';
import 'package:unidirectional_demo/todo_list.dart';

void main() {
  react_client.setClientConfiguration();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) => print(record.toString()));

  var applicationElement = querySelector("#application");
  var actions = new Channel<Action<TodoList>>.broadcast();
  var initialState = window.localStorage.containsKey("unidirectional-demo")
      ? new TodoList.fromJson(JSON.decode(window.localStorage["unidirectional-demo"]))
      : new TodoList.initial();

  var historyState = new EventStream(window.onPopState)
      .map((event) => JSON.decode(event.state))
      .map((json) => new TodoList.fromJson(json))
      .doAction((state) => _logger.info("Popped #${state.filter} off history"));
  var appState = actions.stream.scan(initialState, (state, action) => action(state));

  appState.merge(historyState).listen((state) {
    react.render(todoListView({"actions": actions, "state": state}), applicationElement);
  });

  appState
      .distinct((previous, next) => previous.filter == next.filter)
      .doAction((state) => _logger.info("Pushing #${state.filter} onto history"))
      .listen((state) => window.history.pushState(JSON.encode(state), "TodoMVC", "#${state.filter}"));

  appState
      .map((state) => JSON.encode(state))
      .doAction((state) => _logger.finest("Writing state to local storage"))
      .listen((json) => window.localStorage["unidirectional-demo"] = json);
}

final _logger = new Logger("main");
