// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:redux/redux.dart';

final tasksReducer = combineReducers<List<Task>>([
  TypedReducer<List<Task>, LoadTasksAction>(_setLoadedTasks),
  TypedReducer<List<Task>, DeleteTaskAction>(_deleteTask),
]);

List<Task> _setLoadedTasks(List<Task> tasks, LoadTasksAction action) {
  return action.tasks;
}

List<Task> _deleteTask(List<Task> tasks, DeleteTaskAction action) {
  return tasks..removeWhere((task) => task.id == action.id);
}
