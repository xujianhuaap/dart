// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Like `external_static_member_lowerings_test.dart`, but uses the namespaces
// in the `@JS` annotations instead.

@JS('library1.library2')
library external_static_member_lowerings_with_namespaces_test;

import 'dart:js_util' as js_util;

import 'package:expect/minitest.dart';
import 'package:js/js.dart';

@JS('library3.ExternalStatic')
@staticInterop
class ExternalStatic {
  external static String field;
  @JS('field')
  external static String renamedField;
  external static final String finalField;

  external static String get getSet;
  external static set getSet(String val);
  @JS('getSet')
  external static String get renamedGetSet;
  @JS('getSet')
  external static set renamedGetSet(String val);

  external static String method();
  external static String differentArgsMethod(String a, [String b = '']);
  @JS('method')
  external static String renamedMethod();
}

@JS('library3.ExternalStatic')
@staticInterop
@trustTypes
class ExternalStaticTrustType {
  external static double field;
  external static double get getSet;
  external static double method();
}

void main() {
  // Use `callMethod` instead of top-level external to `eval` since the library
  // is namespaced.
  js_util.callMethod(js_util.globalThis, 'eval', [
    '''
    var library3 = {};
    var library2 = {library3: library3};
    var library1 = {library2: library2};
    globalThis.library1 = library1;

    library3.ExternalStatic = function ExternalStatic() {}
    library3.ExternalStatic.method = function() {
      return 'method';
    }
    library3.ExternalStatic.differentArgsMethod = function(a, b) {
      return a + b;
    }
    library3.ExternalStatic.field = 'field';
    library3.ExternalStatic.finalField = 'finalField';
    library3.ExternalStatic.getSet = 'getSet';
  '''
  ]);
  testClassStaticMembers();
}

void testClassStaticMembers() {
  // Fields.
  expect(ExternalStatic.field, 'field');
  ExternalStatic.field = 'modified';
  expect(ExternalStatic.field, 'modified');
  expect(ExternalStatic.renamedField, 'modified');
  ExternalStatic.renamedField = 'renamedField';
  expect(ExternalStatic.renamedField, 'renamedField');
  expect(ExternalStatic.finalField, 'finalField');

  // Getters and setters.
  expect(ExternalStatic.getSet, 'getSet');
  ExternalStatic.getSet = 'modified';
  expect(ExternalStatic.getSet, 'modified');
  expect(ExternalStatic.renamedGetSet, 'modified');
  ExternalStatic.renamedGetSet = 'renamedGetSet';
  expect(ExternalStatic.renamedGetSet, 'renamedGetSet');

  // Methods and tearoffs.
  expect(ExternalStatic.method(), 'method');
  expect((ExternalStatic.method)(), 'method');
  expect(ExternalStatic.differentArgsMethod('method'), 'method');
  expect((ExternalStatic.differentArgsMethod)('optional', 'method'),
      'optionalmethod');
  expect(ExternalStatic.renamedMethod(), 'method');
  expect((ExternalStatic.renamedMethod)(), 'method');

  // Use wrong return type in conjunction with `@trustTypes`.
  expect(ExternalStaticTrustType.field, 'renamedField');

  expect(ExternalStaticTrustType.getSet, 'renamedGetSet');

  expect(ExternalStaticTrustType.method(), 'method');
  expect((ExternalStaticTrustType.method)(), 'method');
}
