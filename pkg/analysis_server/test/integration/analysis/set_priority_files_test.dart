// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../support/integration_tests.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(SetPriorityFilesTest);
  });
}

@reflectiveTest
class SetPriorityFilesTest extends AbstractAnalysisServerIntegrationTest {
  Future<void> test_options() async {
    var pathname = sourcePath('foo.dart');
    writeFile(pathname, 'class Foo { void baz() {} }');
    writeFile(sourcePath('bar.dart'), 'class Bar { void baz() {} }');

    await standardAnalysisSetup();
    await sendAnalysisSetPriorityFiles([pathname]);

    var status = await analysisFinished;
    var analysisStatus = status.analysis;
    expect(analysisStatus != null && analysisStatus.isAnalyzing, false);
  }
}
