// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_processor.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(UseEffectiveIntegerDivisionTest);
    defineReflectiveTests(UseEffectiveIntegerDivisionMultiTest);
  });
}

@reflectiveTest
class UseEffectiveIntegerDivisionMultiTest extends BulkFixProcessorTest {
  Future<void> test_singleFile() async {
    await resolveTestCode('''
void f() {
  var a = 5;
  var b = 2;
  print((a / ((a / b).toInt())).toInt());
}
''');
    await assertHasFix('''
void f() {
  var a = 5;
  var b = 2;
  print(a ~/ (a ~/ b));
}
''');
  }
}

@reflectiveTest
class UseEffectiveIntegerDivisionTest extends FixProcessorTest {
  @override
  FixKind get kind => DartFixKind.USE_EFFECTIVE_INTEGER_DIVISION;

  Future<void> test_normalDivision() async {
    await resolveTestCode('''
void f() {
  var a = 5;
  var b = 2;
  print((a / b).toInt());
}
''');
    await assertHasFix('''
void f() {
  var a = 5;
  var b = 2;
  print(a ~/ b);
}
''');
  }
}
