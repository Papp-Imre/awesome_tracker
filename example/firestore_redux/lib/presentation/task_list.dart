// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/containers/app_loading.dart';
import 'package:fire_redux_sample/containers/task/details.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/loading_indicator.dart';
import 'package:fire_redux_sample/presentation/task_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task, bool) onCheckboxChanged;
  final Function(Task) onRemove;
  final Function(Task) onUndoRemove;

  TaskList({
    Key key,
    @required this.tasks,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, loading) {
      return loading
          ? LoadingIndicator(key: ArchSampleKeys.tasksLoading)
          : _buildListView();
    });
  }

  ListView _buildListView() {
    return ListView.builder(
      key: ArchSampleKeys.taskList,
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];

        return TaskItem(
          task: task,
          onDismissed: (direction) {
            _removeTask(context, task);
          },
          onTap: () => _onTaskTap(context, task),
          onCheckboxChanged: (complete) {
            onCheckboxChanged(task, complete);
          },
        );
      },
    );
  }

  void _removeTask(BuildContext context, Task task) {
    onRemove(task);

    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).backgroundColor,
        content: Text(
          ArchSampleLocalizations.of(context).taskDeleted(task.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => onUndoRemove(task),
        )));
  }

  void _onTaskTap(BuildContext context, Task task) {
    Navigator
        .of(context)
        .push(MaterialPageRoute(
          builder: (_) => TaskDetails(id: task.id),
        ))
        .then((removedTask) {
      if (removedTask != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            content: Text(
              ArchSampleLocalizations.of(context).taskDeleted(task.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                onUndoRemove(task);
              },
            )));
      }
    });
  }
}
