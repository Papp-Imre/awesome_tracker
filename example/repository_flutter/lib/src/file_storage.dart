// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:repository/repository.dart';

/// Loads and saves a List of Tasks using a text file stored on the device.
///
/// Note: This class has no direct dependencies on any Flutter dependencies.
/// Instead, the `getDirectory` method should be injected. This allows for
/// testing.
class FileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  Future<List<TaskEntity>> loadTasks() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
    final tasks = (json['tasks'])
        .map<TaskEntity>((todo) => TaskEntity.fromJson(todo))
        .toList();

    return tasks;
  }

  Future<File> saveTasks(List<TaskEntity> tasks) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'tasks': tasks.map((todo) => todo.toJson()).toList(),
    }));
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
