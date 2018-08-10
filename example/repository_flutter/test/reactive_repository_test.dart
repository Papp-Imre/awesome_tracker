// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:repository/repository.dart';
import 'package:repository_flutter/repository_flutter.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

main() {
  group('ReactiveTasksRepository', () {
    List<TaskEntity> createTasks([String task = "Task"]) {
      return [
        TaskEntity(task, "1", "Hallo", false),
        TaskEntity(task, "2", "Friend", false),
        TaskEntity(task, "3", "Yo", false),
      ];
    }

    test('should load tasks from the base repo and send them to the client',
        () {
      final tasks = createTasks();
      final repository = MockTasksRepository();
      final reactiveRepository = ReactiveTasksRepositoryFlutter(
        repository: repository,
        seedValue: tasks,
      );

      when(repository.loadTasks()).thenReturn(Future.value(<TaskEntity>[]));

      expect(reactiveRepository.tasks(), emits(tasks));
    });

    test('should only load from the base repo once', () {
      final tasks = createTasks();
      final repository = MockTasksRepository();
      final reactiveRepository = ReactiveTasksRepositoryFlutter(
        repository: repository,
        seedValue: tasks,
      );

      when(repository.loadTasks()).thenReturn(Future.value(tasks));

      expect(reactiveRepository.tasks(), emits(tasks));
      expect(reactiveRepository.tasks(), emits(tasks));

      verify(repository.loadTasks()).called(1);
    });

    test('should add tasks to the repository and emit the change', () async {
      final tasks = createTasks();
      final repository = MockTasksRepository();
      final reactiveRepository = ReactiveTasksRepositoryFlutter(
        repository: repository,
        seedValue: [],
      );

      when(repository.loadTasks()).thenReturn(new Future.value(<TaskEntity>[]));
      when(repository.saveTasks(tasks)).thenReturn(Future.value());

      await reactiveRepository.addNewTask(tasks.first);

      verify(repository.saveTasks(typed(any)));
      expect(reactiveRepository.tasks(), emits([tasks.first]));
    });

    test('should update a todo in the repository and emit the change',
        () async {
      final tasks = createTasks();
      final repository = MockTasksRepository();
      final reactiveRepository = ReactiveTasksRepositoryFlutter(
        repository: repository,
        seedValue: tasks,
      );
      final update = createTasks("task");

      when(repository.loadTasks()).thenReturn(Future.value(tasks));
      when(repository.saveTasks(typed(any))).thenReturn(Future.value());

      await reactiveRepository.updateTask(update.first);

      verify(repository.saveTasks(typed(any)));
      expect(
        reactiveRepository.tasks(),
        emits([update[0], tasks[1], tasks[2]]),
      );
    });

    test('should remove tasks from the repo and emit the change', () async {
      final repository = MockTasksRepository();
      final tasks = createTasks();
      final reactiveRepository = ReactiveTasksRepositoryFlutter(
        repository: repository,
        seedValue: tasks,
      );
      final future = Future.value(tasks);

      when(repository.loadTasks()).thenReturn(future);
      when(repository.saveTasks(typed(any))).thenReturn(Future.value());

      await reactiveRepository.deleteTask([tasks.first.id, tasks.last.id]);

      verify(repository.saveTasks(typed(any)));
      expect(reactiveRepository.tasks(), emits([tasks[1]]));
    });
  });
}
