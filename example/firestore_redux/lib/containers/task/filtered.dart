// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/task_list.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FilteredTasks extends StatelessWidget {
  FilteredTasks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TaskList(
          tasks: vm.tasks,
          onCheckboxChanged: vm.onCheckboxChanged,
          onRemove: vm.onRemove,
          onUndoRemove: vm.onUndoRemove,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Task> tasks;
  final bool loading;
  final Function(Task, bool) onCheckboxChanged;
  final Function(Task) onRemove;
  final Function(Task) onUndoRemove;

  _ViewModel({
    @required this.tasks,
    @required this.loading,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      tasks: filteredTasksSelector(
        tasksSelector(store.state),
        activeFilterSelector(store.state),
      ),
      loading: store.state.isLoading,
      onCheckboxChanged: (task, complete) {
        store.dispatch(UpdateTaskAction(
          task.id,
          task.copyWith(complete: !task.complete),
        ));
      },
      onRemove: (task) {
        store.dispatch(DeleteTaskAction(task.id));
      },
      onUndoRemove: (task) {
        store.dispatch(AddTaskAction(task));
      },
    );
  }
}
