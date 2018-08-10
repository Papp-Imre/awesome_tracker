// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Task> tasks;
  final AppTab activeTab;
  final VisibilityFilter activeFilter;

  AppState({
    this.isLoading = false,
    this.tasks = const [],
    this.activeTab = AppTab.tasks,
    this.activeFilter = VisibilityFilter.all,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Task> tasks,
    AppTab activeTab,
    VisibilityFilter activeFilter,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      tasks.hashCode ^
      activeTab.hashCode ^
      activeFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          tasks == other.tasks &&
          activeTab == other.activeTab &&
          activeFilter == other.activeFilter;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, tasks: $tasks, activeTab: $activeTab, activeFilter: $activeFilter}';
  }
}
