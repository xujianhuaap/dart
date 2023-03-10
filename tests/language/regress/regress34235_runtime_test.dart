// TODO(multitest): This was automatically migrated from a multitest and may
// contain strange or dead code.

// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(51557): Decide if the mixins being applied in this test should be
// "mixin", "mixin class" or the test should be left at 2.19.
// @dart=2.19

class Base {
  void foo() {}
}

class M1 {
  void foo(
      // Prevent formatter from joining the line below to the one above

      ) {}
}

class BaseWithM1 = Base with M1;

class M2 {
  void foo() {}
}

class Derived extends BaseWithM1 with M2 {}

main() {
  new Derived().foo();
}
