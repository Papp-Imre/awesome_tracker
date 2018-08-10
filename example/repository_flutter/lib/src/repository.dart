// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:repository/repository.dart';
import 'web_client.dart';
import 'file_storage.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Tasks and Persist tasks.
class TasksRepositoryFlutter implements TasksRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TasksRepositoryFlutter({
    @required this.fileStorage,
    this.webClient = const WebClient(),
  });

  /// Loads tasks first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Tasks from a Web Client.
  @override
  Future<List<TaskEntity>> loadTasks() async {
    try {
      return await fileStorage.loadTasks();
    } catch (e) {
      final tasks = await webClient.fetchTasks();

      fileStorage.saveTasks(tasks);

      return tasks;
    }
  }

  // Persists tasks to local disk and the web
  @override
  Future saveTasks(List<TaskEntity> tasks) {
    return Future.wait<dynamic>([
      fileStorage.saveTasks(tasks),
      webClient.postTasks(tasks),
    ]);
  }
}
