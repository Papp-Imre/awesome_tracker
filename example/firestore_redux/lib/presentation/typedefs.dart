// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';

typedef TaskAdder(Task task);

typedef TaskRemover(String id);

typedef TaskUpdater(String id, Task task);
