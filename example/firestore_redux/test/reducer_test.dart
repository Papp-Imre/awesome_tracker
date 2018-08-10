// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

main() {
  group('State Reducer', () {
    test('should load tasks into store', () {
      final task1 = Task('a');
      final task2 = Task('b');
      final task3 = Task('c', complete: true);
      final tasks = [
        task1,
        task2,
        task3,
      ];
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
      );

      expect(tasksSelector(store.state), []);

      store.dispatch(LoadTasksAction(tasks));

      expect(tasksSelector(store.state), tasks);
    });

    test('should update the VisibilityFilter', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeFilter: VisibilityFilter.active),
      );

      store.dispatch(UpdateFilterAction(VisibilityFilter.completed));

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeTab: AppTab.tasks),
      );

      store.dispatch(UpdateTabAction(AppTab.stats));

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}
