// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(51557): Decide if the mixins being applied in this test should be
// "mixin", "mixin class" or the test should be left at 2.19.
// @dart=2.19

// Test that generic types in mixins are handled.

import 'package:expect/expect.dart';

class M<T> {
  T field1 = 0;
  //         ^
  // [analyzer] COMPILE_TIME_ERROR.INVALID_ASSIGNMENT
  // [cfe] A value of type 'int' can't be assigned to a variable of type 'T'.
  T field2 = 0 as dynamic;
}

class A<U> {}

class C1<V> = Object with M<V>;
class C2 = Object with M<int>;
class C3 = Object with M<String>;

main() {
  // no error: 0 is an int
  new C1<int>();
  new C2();

  // type error: 0 is not a string
  Expect.throwsTypeError(() => new C1<String>());
  Expect.throws(() => new C3());
}
