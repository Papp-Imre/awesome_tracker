# firebase_flutter_repository

A reactive version of the tasks repository and user repository backed by Firestore and FirebaseAuth for Flutter.

## Defines how to log in

This library provides a concrete implementation of the `UserRepository` class. It uses the `firebase_auth` package and anonymous login as the mechanism and returns a `UserEntity`.

## Defines how to interact with Tasks

This library provides a concrete implementation of the `ReactiveTasksRepository`.

To listen for real-time changes, it streams `TaskEntity` objects stored in the `tasks` collection on Firestore. To create, update, and delete tasks, it pushes changes to the `tasks` collection or individual documents.
