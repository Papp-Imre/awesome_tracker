// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:repository_flutter/src/file_storage.dart';
import 'package:test/test.dart';
import 'package:repository/repository.dart';

main() {
  group('FileStorage', () {
    final tasks = [TaskEntity("Task", "1", "Hallo", false)];
    final directory = Directory.systemTemp.createTemp('__storage_test__');
    final storage = FileStorage(
      '_test_tag_',
      () => directory,
    );

    tearDownAll(() async {
      final tempDirectory = await directory;

      tempDirectory.deleteSync(recursive: true);
    });

    test('Should persist TaskEntities to disk', () async {
      final file = await storage.saveTasks(tasks);

      expect(file.existsSync(), isTrue);
    });

    test('Should load TaskEntities from disk', () async {
      final loadedTasks = await storage.loadTasks();

      expect(loadedTasks, tasks);
    });
  });
}
