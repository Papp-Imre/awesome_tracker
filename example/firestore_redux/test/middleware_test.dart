// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/middleware/store_tasks_middleware.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:repository/repository.dart';

class MockReactiveTasksRepository extends Mock
    implements ReactiveTasksRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

main() {
  group('Middleware', () {
    test('should log in and start listening for changes', () {
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository)
          ..add(captor),
      );

      when(userRepository.login()).thenReturn(SynchronousFuture(null));
      when(tasksRepository.tasks())
          .thenReturn(StreamController<List<TaskEntity>>().stream);

      store.dispatch(InitAppAction());

      verify(userRepository.login());
      verify(tasksRepository.tasks());
      verify(captor.call(
        typed(any),
        isInstanceOf<ConnectToDataSourceAction>(),
        typed(any),
      ));
    });

    test('should convert entities to tasks', () async {
      // ignore: close_sinks
      final controller = StreamController<List<TaskEntity>>(sync: true);
      final task = Task('A');
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository)
          ..add(captor),
      );

      when(tasksRepository.tasks()).thenReturn(controller.stream);

      store.dispatch(ConnectToDataSourceAction());
      controller.add([task.toEntity()]);

      verify(captor.call(
        typed(any),
        isInstanceOf<LoadTasksAction>(),
        typed(any),
      ));
    });

    test('should send tasks to the repository', () {
      final task = Task("T");
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(AddTaskAction(task));
      verify(tasksRepository.addNewTask(task.toEntity()));
    });

    test('should clear the completed tasks from the repository', () {
      final taskA = Task("A");
      final taskB = Task("B", complete: true);
      final taskC = Task("C", complete: true);
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(tasks: [
          taskA,
          taskB,
          taskC,
        ]),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(ClearCompletedAction());

      verify(tasksRepository.deleteTask([taskB.id, taskC.id]));
    });

    test('should inform the repository to toggle all tasks active', () {
      final taskA = Task("A", complete: true);
      final taskB = Task("B", complete: true);
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(tasks: [
          taskA,
          taskB,
        ]),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(tasksRepository
          .updateTask(taskA.copyWith(complete: false).toEntity()));
      verify(tasksRepository
          .updateTask(taskB.copyWith(complete: false).toEntity()));
    });

    test('should inform the repository to toggle all tasks complete', () {
      final taskA = Task("A");
      final taskB = Task("B", complete: true);
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(tasks: [
          taskA,
          taskB,
        ]),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(ToggleAllAction());

      verify(tasksRepository
          .updateTask(taskA.copyWith(complete: true).toEntity()));
    });

    test('should update a task on firestore', () {
      final task = Task("A");
      final update = task.copyWith(task: "B");
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(tasks: [task]),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(UpdateTaskAction(task.id, update));

      verify(tasksRepository.updateTask(update.toEntity()));
    });

    test('should delete a task on firestore', () {
      final task = Task("A");
      final tasksRepository = MockReactiveTasksRepository();
      final userRepository = MockUserRepository();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(tasks: [task]),
        middleware: createStoreTasksMiddleware(tasksRepository, userRepository),
      );

      store.dispatch(DeleteTaskAction(task.id));

      verify(tasksRepository.deleteTask([task.id]));
    });
  });
}
