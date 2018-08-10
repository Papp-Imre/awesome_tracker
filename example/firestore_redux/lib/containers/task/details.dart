// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/details_screen.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TaskDetails extends StatelessWidget {
  final String id;

  TaskDetails({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      ignoreChange: (state) => taskSelector(state.tasks, id).isNotPresent,
      converter: (Store<AppState> store) {
        return _ViewModel.from(store, id);
      },
      builder: (context, vm) {
        return DetailsScreen(
          task: vm.task,
          onDelete: vm.onDelete,
          toggleCompleted: vm.toggleCompleted,
        );
      },
    );
  }
}

class _ViewModel {
  final Task task;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  _ViewModel({
    @required this.task,
    @required this.onDelete,
    @required this.toggleCompleted,
  });

  factory _ViewModel.from(Store<AppState> store, String id) {
    final task = taskSelector(tasksSelector(store.state), id).value;

    return _ViewModel(
      task: task,
      onDelete: () => store.dispatch(DeleteTaskAction(task.id)),
      toggleCompleted: (isComplete) {
        store.dispatch(UpdateTaskAction(
          task.id,
          task.copyWith(complete: isComplete),
        ));
      },
    );
  }
}
