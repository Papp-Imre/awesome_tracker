// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:repository/repository.dart';
import 'package:repository_flutter/repository_flutter.dart';

/// We create two Mocks for our Web Client and File Storage. We will use these
/// mock classes to verify the behavior of the TasksRepository.
class MockFileStorage extends Mock implements FileStorage {}

class MockWebClient extends Mock implements WebClient {}

main() {
  group('TasksRepository', () {
    List<TaskEntity> createTasks() {
      return [TaskEntity("Task", "1", "Hallo", false)];
    }

    test(
        'should load tasks from File Storage if they exist without calling the web client',
        () {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = TasksRepositoryFlutter(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final tasks = createTasks();

      // We'll use our mock throughout the tests to set certain conditions. In
      // this first test, we want to mock out our file storage to return a
      // list of Tasks that we define here in our test!
      when(fileStorage.loadTasks()).thenReturn(Future.value(tasks));

      expect(repository.loadTasks(), completion(tasks));
      verifyNever(webClient.fetchTasks());
    });

    test(
        'should fetch tasks from the Web Client if the file storage throws a synchronous error',
        () async {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = TasksRepositoryFlutter(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final tasks = createTasks();

      // In this instance, we'll ask our Mock to throw an error. When it does,
      // we expect the web client to be called instead.
      when(fileStorage.loadTasks()).thenThrow("Uh ohhhh");
      when(webClient.fetchTasks()).thenReturn(Future.value(tasks));

      // We check that the correct tasks were returned, and that the
      // webClient.fetchTasks method was in fact called!
      expect(await repository.loadTasks(), tasks);
      verify(webClient.fetchTasks());
    });

    test(
        'should fetch tasks from the Web Client if the File storage returns an async error',
        () async {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = TasksRepositoryFlutter(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final tasks = createTasks();

      when(fileStorage.loadTasks()).thenThrow(Exception("Oh no."));
      when(webClient.fetchTasks()).thenReturn(Future.value(tasks));

      expect(await repository.loadTasks(), tasks);
      verify(webClient.fetchTasks());
    });

    test('should persist the tasks to local disk and the web client', () {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = TasksRepositoryFlutter(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final tasks = createTasks();

      when(fileStorage.saveTasks(tasks))
          .thenReturn(Future.value(File('falsch')));
      when(webClient.postTasks(tasks)).thenReturn(Future.value(true));

      // In this case, we just want to verify we're correctly persisting to all
      // the storage mechanisms we care about.
      expect(repository.saveTasks(tasks), completes);
      verify(fileStorage.saveTasks(tasks));
      verify(webClient.postTasks(tasks));
    });
  });
}
