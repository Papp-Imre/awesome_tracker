// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/models/visibility_filter.dart';

class ClearCompletedAction {}

class ToggleAllAction {
  ToggleAllAction();

  @override
  String toString() {
    return 'ToggleAllAction{}';
  }
}

class LoadTasksAction {
  final List<Task> tasks;

  LoadTasksAction(this.tasks);

  @override
  String toString() {
    return 'LoadTasksAction{tasks: $tasks}';
  }
}

class UpdateTaskAction {
  final String id;
  final Task updatedTask;

  UpdateTaskAction(this.id, this.updatedTask);

  @override
  String toString() {
    return 'UpdateTaskAction{id: $id, updatedTask: $updatedTask}';
  }
}

class DeleteTaskAction {
  final String id;

  DeleteTaskAction(this.id);

  @override
  String toString() {
    return 'DeleteTaskAction{id: $id}';
  }
}

class AddTaskAction {
  final Task task;

  AddTaskAction(this.task);

  @override
  String toString() {
    return 'AddTaskAction{task: $task}';
  }
}

class InitAppAction {
  @override
  String toString() {
    return 'InitAppAction{}';
  }
}

class ConnectToDataSourceAction {
  @override
  String toString() {
    return 'ConnectToDataSourceAction{}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}
