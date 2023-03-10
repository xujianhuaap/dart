// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(51557): Decide if the mixins being applied in this test should be
// "mixin", "mixin class" or the test should be left at 2.19.
// @dart=2.19

library lib1;

import "mixin_shared.dart";
import "mixin_test.dart";

class Mixin {
  foo() => "lib1.Mixin";
}

class A extends Object with NonDeferredMixin {
  foo() {
    return "A with " + super.foo();
  }
}

class B extends Object with Mixin {
  foo() {
    return "B with " + super.foo();
  }
}

class C extends Object with Mixin, NonDeferredMixin1 {
  foo() {
    return "C with " + super.foo();
  }
}

class D extends Object with NonDeferredMixin2, Mixin {
  foo() {
    return "D with " + super.foo();
  }
}

class E extends Object with SharedMixin {
  foo() {
    return "E with " + super.foo();
  }
}
