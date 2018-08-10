// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/core.dart';

main() {
  group('Selectors', () {
    test('should list the active tasks', () {
      final taskA = Task('a');
      final taskB = Task('b');
      final tasks = [
        taskA,
        taskB,
        Task('c', complete: true),
      ];

      expect(activeTasksSelector(tasks), [taskA, taskB]);
    });

    test('should calculate the number of active tasks', () {
      final tasks = [
        Task('a'),
        Task('b'),
        Task('c', complete: true),
      ];

      expect(numActiveSelector(tasks), 2);
    });

    test('should list the completed tasks', () {
      final task = Task('c', complete: true);
      final tasks = [
        Task('a'),
        Task('b'),
        task,
      ];

      expect(completeTasksSelector(tasks), [task]);
    });

    test('should calculate the number of completed tasks', () {
      final tasks = [
        Task('a'),
        Task('b'),
        Task('c', complete: true),
      ];

      expect(numCompletedSelector(tasks), 1);
    });

    test('should return all tasks if the VisibilityFilter is all', () {
      final tasks = [
        Task('a'),
        Task('b'),
        Task('c', complete: true),
      ];

      expect(filteredTasksSelector(tasks, VisibilityFilter.all), tasks);
    });

    test('should return active tasks if the VisibilityFilter is active', () {
      final task1 = Task('a');
      final task2 = Task('b');
      final task3 = Task('c', complete: true);
      final tasks = [
        task1,
        task2,
        task3,
      ];

      expect(filteredTasksSelector(tasks, VisibilityFilter.active), [
        task1,
        task2,
      ]);
    });

    test('should return completed tasks if the VisibilityFilter is completed',
        () {
      final task1 = Task('a');
      final task2 = Task('b');
      final task3 = Task('c', complete: true);
      final tasks = [
        task1,
        task2,
        task3,
      ];

      expect(filteredTasksSelector(tasks, VisibilityFilter.completed), [task3]);
    });

    test('should return an Optional task based on id', () {
      final task1 = Task('a', id: "1");
      final task2 = Task('b');
      final task3 = Task('c', complete: true);
      final tasks = [
        task1,
        task2,
        task3,
      ];

      expect(taskSelector(tasks, "1"), Optional.of(task1));
    });

    test('should return an absent Optional if the id is not found', () {
      final task1 = Task('a', id: "1");
      final task2 = Task('b');
      final task3 = Task('c', complete: true);
      final tasks = [
        task1,
        task2,
        task3,
      ];

      expect(taskSelector(tasks, "2"), Optional.absent());
    });
  });
}
