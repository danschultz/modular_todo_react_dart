# Unidirectional Dart+React Demo

A TodoMVC app that prototypes a modular unidirectional data flow inspired by [Elm](https://github.com/evancz/elm-architecture-tutorial).

The application is split into a tree of modules, where each module is composed of a view, a model, a set of actions and an update stream that is passed by its parent. When a parent component receives an update request from a child, it invokes the requested action, then passes the modified state to its parent. This cycle repeats itself up the module tree until it reaches the root node. At which point, the root node will perform a rerender with the updated application state.
 
To illustrate this architecture, lets describe the flow for when a user marks a todo as completed. The module tree for this application is pretty simple. It's composed of a TodoList and a Todo module, where the TodoList is the parent module and Todo's are the child modules. When the TodoList component instantiates a Todo component, it passes it a `Channel` as a property. When the Todo view wants its state to change, it adds an action onto the `Channel` which is a request to the parent to update the todo's model.

## Goals

* *Unidirectional.* The whole app is driven by an endless `Render -> User Action -> State Modification -> Render` loop.
* *Modular.* So it can scale.
* *No singletons.* They suck.
* *Functional.* I've heard it's cool.
* *Immutable API.* Exposed API's are immutable. Backing lists/maps might be mutable.
* *Typed throughout.* Cuz no one has a clue what's in Flux's actions.
