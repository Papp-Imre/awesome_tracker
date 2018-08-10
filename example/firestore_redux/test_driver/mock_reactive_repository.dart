//// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
//// Use of this source code is governed by the MIT license that can be found
//// in the LICENSE file.
//
//import 'dart:async';
//
//import 'package:repository/repository.dart';
//
//class MockUserRepository implements UserRepository {
//  @override
//  Future<UserEntity> login([
//    delayAuth = const Duration(milliseconds: 200),
//  ]) {
//    return Future<UserEntity>.delayed(delayAuth);
//  }
//}
//
//class MockReactiveTasksRepository implements ReactiveTasksRepository {
//  // ignore: close_sinks
//  final controller = StreamController<List<TaskEntity>>();
//  List<TaskEntity> _tasks = [];
//
//  @override
//  Future<void> addNewTask(TaskEntity newTask) async {
//    _tasks.add(newTask);
//    controller.add(_tasks);
//  }
//
//  @override
//  Future<List<void>> deleteTask(List<String> idList) async {
//    _tasks.removeWhere((task) => idList.contains(task.id));
//    controller.add(_tasks);
//
//    return [];
//  }
//
//  @override
//  Stream<List<TaskEntity>> tasks({webClient = const WebClient()}) async* {
//    _tasks = await webClient.fetchTasks();
//
//    yield _tasks;
//
//    await for (var latest in controller.stream) {
//      yield latest;
//    }
//  }
//
//  @override
//  Future<void> updateTask(TaskEntity task) async {
//    _tasks[_tasks.indexWhere((t) => t.id == task.id)] = task;
//
//    controller.add(_tasks);
//  }
//}
