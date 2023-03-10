// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Regression test ensuring that only ObjectArrays are handed to the VM code.

// @dart = 2.9

import "package:expect/expect.dart";

class StringJoinTest {
  static testMain() {
    List<String> ga = <String>[];
    ga.add("a");
    ga.add("b");
    Expect.equals("ab", ga.join());
    Expect.equals("ab", ga.join(""));
  }
}

main() {
  StringJoinTest.testMain();
}
