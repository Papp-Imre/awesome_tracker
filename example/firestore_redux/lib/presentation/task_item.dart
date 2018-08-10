// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class TaskItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Task task;

  TaskItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.taskItem(task.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: ArchSampleKeys.taskItemCheckbox(task.id),
          value: task.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Hero(
          tag: '${task.id}__heroTag',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              task.task,
              key: ArchSampleKeys.taskItemTask(task.id),
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        subtitle: Text(
          task.note,
          key: ArchSampleKeys.taskItemNote(task.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }
}
