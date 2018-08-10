// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repository/repository.dart';

class FirestoreReactiveTasksRepository implements ReactiveTasksRepository {
  static const String path = 'task';

  final Firestore firestore;

  const FirestoreReactiveTasksRepository(this.firestore);

  @override
  Future<void> addNewTask(TaskEntity task) {
    return firestore.collection(path).document(task.id).setData(task.toJson());
  }

  @override
  Future<void> deleteTask(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Stream<List<TaskEntity>> tasks() {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return TaskEntity(
          doc['task'],
          doc.documentID,
          doc['note'] ?? '',
          doc['complete'] ?? false,
        );
      }).toList();
    });
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return firestore
        .collection(path)
        .document(task.id)
        .updateData(task.toJson());
  }
}
