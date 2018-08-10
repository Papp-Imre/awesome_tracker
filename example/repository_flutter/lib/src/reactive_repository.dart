// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:repository/repository.dart';

/// A class that glues together our local file storage and web client. It has a
/// clear responsibility: Load Tasks and Persist tasks.
class ReactiveTasksRepositoryFlutter implements ReactiveTasksRepository {
  final TasksRepository _repository;
  final BehaviorSubject<List<TaskEntity>> _subject;
  bool _loaded = false;

  ReactiveTasksRepositoryFlutter({
    @required TasksRepository repository,
    List<TaskEntity> seedValue,
  })  : this._repository = repository,
        this._subject = BehaviorSubject<List<TaskEntity>>(seedValue: seedValue);

  @override
  Future<void> addNewTask(TaskEntity todo) async {
    _subject.add(List.unmodifiable([]
      ..addAll(_subject.value ?? [])
      ..add(todo)));

    await _repository.saveTasks(_subject.value);
  }

  @override
  Future<void> deleteTask(List<String> idList) async {
    _subject.add(
      List<TaskEntity>.unmodifiable(_subject.value.fold<List<TaskEntity>>(
        <TaskEntity>[],
        (prev, entity) {
          return idList.contains(entity.id) ? prev : (prev..add(entity));
        },
      )),
    );

    await _repository.saveTasks(_subject.value);
  }

  @override
  Stream<List<TaskEntity>> tasks() {
    if (!_loaded) _loadTasks();

    return _subject.stream;
  }

  void _loadTasks() {
    _loaded = true;

    _repository.loadTasks().then((entities) {
      _subject.add(List<TaskEntity>.unmodifiable(
        []..addAll(_subject.value ?? [])..addAll(entities),
      ));
    });
  }

  @override
  Future<void> updateTask(TaskEntity update) async {
    _subject.add(
      List<TaskEntity>.unmodifiable(_subject.value.fold<List<TaskEntity>>(
        <TaskEntity>[],
        (prev, entity) => prev..add(entity.id == update.id ? update : entity),
      )),
    );

    await _repository.saveTasks(_subject.value);
  }
}
