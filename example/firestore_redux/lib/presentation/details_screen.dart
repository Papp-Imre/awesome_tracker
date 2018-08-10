// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/containers/task/edit.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class DetailsScreen extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  DetailsScreen({
    Key key,
    @required this.task,
    @required this.onDelete,
    @required this.toggleCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.taskDetails),
        actions: [
          IconButton(
            tooltip: localizations.deleteTask,
            key: ArchSampleKeys.deleteTaskButton,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
              Navigator.pop(context, task);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Checkbox(
                    value: task.complete,
                    onChanged: toggleCompleted,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: '${task.id}__heroTag',
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: 8.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            task.task,
                            key: ArchSampleKeys.detailsTaskItemTask,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                      ),
                      Text(
                        task.note,
                        key: ArchSampleKeys.detailsTaskItemNote,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.editTaskFab,
        tooltip: localizations.editTask,
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditTask(
                  taskObj: task,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
