// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';

class ArchSampleKeys {
  // Home Screens
  static final homeScreen = const Key('__homeScreen__');
  static final addTaskFab = const Key('__addTaskFab__');
  static final snackbar = const Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Tasks
  static final taskList = const Key('__taskList__');
  static final tasksLoading = const Key('__tasksLoading__');
  static final taskItem = (String id) => Key('TaskItem__${id}');
  static final taskItemCheckbox =
      (String id) => Key('TaskItem__${id}__Checkbox');
  static final taskItemTask = (String id) => Key('TaskItem__${id}__Task');
  static final taskItemNote = (String id) => Key('TaskItem__${id}__Note');

  // Tabs
  static final tabs = const Key('__tabs__');
  static final taskTab = const Key('__taskTab__');
  static final statsTab = const Key('__statsTab__');

  // Extra Actions
  static final extraActionsButton = const Key('__extraActionsButton__');
  static final toggleAll = const Key('__markAllDone__');
  static final clearCompleted = const Key('__clearCompleted__');

  // Filters
  static final filterButton = const Key('__filterButton__');
  static final allFilter = const Key('__allFilter__');
  static final activeFilter = const Key('__activeFilter__');
  static final completedFilter = const Key('__completedFilter__');

  // Stats
  static final statsCounter = const Key('__statsCounter__');
  static final statsLoading = const Key('__statsLoading__');
  static final statsNumActive = const Key('__statsActiveItems__');
  static final statsNumCompleted = const Key('__statsCompletedItems__');

  // Details Screen
  static final editTaskFab = const Key('__editTaskFab__');
  static final deleteTaskButton = const Key('__deleteTaskFab__');
  static final taskDetailsScreen = const Key('__taskDetailsScreen__');
  static final detailsTaskItemCheckbox = Key('DetailsTask__Checkbox');
  static final detailsTaskItemTask = Key('DetailsTask__Task');
  static final detailsTaskItemNote = Key('DetailsTask__Note');

  // Add Screen
  static final addTaskScreen = const Key('__addTaskScreen__');
  static final saveNewTask = const Key('__saveNewTask__');

  // Edit Screen
  static final editTaskScreen = const Key('__editTaskScreen__');
  static final saveTaskFab = const Key('__saveTaskFab__');
}
