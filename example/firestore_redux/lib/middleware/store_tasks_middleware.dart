// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:redux/redux.dart';
import 'package:repository/repository.dart';

List<Middleware<AppState>> createStoreTasksMiddleware(
  ReactiveTasksRepository tasksRepository,
  UserRepository userRepository,
) {
  return [
    TypedMiddleware<AppState, InitAppAction>(
      _firestoreSignIn(userRepository),
    ),
    TypedMiddleware<AppState, ConnectToDataSourceAction>(
      _firestoreConnect(tasksRepository),
    ),
    TypedMiddleware<AppState, AddTaskAction>(
      _firestoreSaveNewTask(tasksRepository),
    ),
    TypedMiddleware<AppState, DeleteTaskAction>(
      _firestoreDeleteTask(tasksRepository),
    ),
    TypedMiddleware<AppState, UpdateTaskAction>(
      _firestoreUpdateTask(tasksRepository),
    ),
    TypedMiddleware<AppState, ToggleAllAction>(
      _firestoreToggleAll(tasksRepository),
    ),
    TypedMiddleware<AppState, ClearCompletedAction>(
      _firestoreClearCompleted(tasksRepository),
    ),
  ];
}

void Function(
  Store<AppState> store,
  InitAppAction action,
  NextDispatcher next,
) _firestoreSignIn(
  UserRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.login().then((_) {
      store.dispatch(ConnectToDataSourceAction());
    });
  };
}

void Function(
  Store<AppState> store,
  ConnectToDataSourceAction action,
  NextDispatcher next,
) _firestoreConnect(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.tasks().listen((tasks) {
      store.dispatch(LoadTasksAction(tasks.map(Task.fromEntity).toList()));
    });
  };
}

void Function(
  Store<AppState> store,
  AddTaskAction action,
  NextDispatcher next,
) _firestoreSaveNewTask(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.addNewTask(action.task.toEntity());
  };
}

void Function(
  Store<AppState> store,
  DeleteTaskAction action,
  NextDispatcher next,
) _firestoreDeleteTask(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.deleteTask([action.id]);
  };
}

void Function(
  Store<AppState> store,
  UpdateTaskAction action,
  NextDispatcher next,
) _firestoreUpdateTask(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);
    repository.updateTask(action.updatedTask.toEntity());
  };
}

void Function(
  Store<AppState> store,
  ToggleAllAction action,
  NextDispatcher next,
) _firestoreToggleAll(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);
    var tasks = tasksSelector(store.state);

    for (var task in tasks) {
      if (allCompleteSelector(tasks)) {
        if (task.complete)
          repository.updateTask(task.copyWith(complete: false).toEntity());
      } else {
        if (!task.complete)
          repository.updateTask(task.copyWith(complete: true).toEntity());
      }
    }
  };
}

void Function(
  Store<AppState> store,
  ClearCompletedAction action,
  NextDispatcher next,
) _firestoreClearCompleted(
  ReactiveTasksRepository repository,
) {
  return (store, action, next) {
    next(action);

    repository.deleteTask(
      completeTasksSelector(tasksSelector(store.state))
          .map((task) => task.id)
          .toList(),
    );
  };
}
