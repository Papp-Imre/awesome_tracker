// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:flutter_architecture_samples/optional.dart';

List<Task> tasksSelector(AppState state) => state.tasks;

VisibilityFilter activeFilterSelector(AppState state) => state.activeFilter;

AppTab activeTabSelector(AppState state) => state.activeTab;

bool isLoadingSelector(AppState state) => state.isLoading;

bool allCompleteSelector(List<Task> tasks) =>
    tasks.every((task) => task.complete);

int numActiveSelector(List<Task> tasks) => activeTasksSelector(tasks).length;

int numCompletedSelector(List<Task> tasks) =>
    completeTasksSelector(tasks).length;

List<Task> activeTasksSelector(List<Task> tasks) =>
    tasks.where((task) => !task.complete).toList();

List<Task> completeTasksSelector(List<Task> tasks) =>
    tasks.where((task) => task.complete).toList();

List<Task> filteredTasksSelector(
  List<Task> tasks,
  VisibilityFilter activeFilter,
) {
  switch (activeFilter) {
    case VisibilityFilter.active:
      return activeTasksSelector(tasks);
    case VisibilityFilter.completed:
      return completeTasksSelector(tasks);
    case VisibilityFilter.all:
    default:
      return tasks;
  }
}

Optional<Task> taskSelector(List<Task> tasks, String id) {
  try {
    return Optional.of(tasks.firstWhere((task) => task.id == id));
  } catch (e) {
    return Optional.absent();
  }
}
