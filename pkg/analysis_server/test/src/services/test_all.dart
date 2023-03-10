// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'completion/test_all.dart' as completion;
import 'correction/test_all.dart' as correction;
import 'flutter/test_all.dart' as flutter;
import 'refactoring/test_all.dart' as refactoring;

void main() {
  defineReflectiveSuite(() {
    completion.main();
    correction.main();
    flutter.main();
    refactoring.main();
  }, name: 'services');
}
