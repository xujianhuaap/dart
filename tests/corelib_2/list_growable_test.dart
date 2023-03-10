// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

import "package:expect/expect.dart";

main() {
  var a;
  a = [];
  a.add(499);
  Expect.equals(1, a.length);
  Expect.equals(499, a[0]);
  a.clear();
  Expect.equals(0, a.length);
  Expect.throwsRangeError(() => a[0]);

  a = new List<dynamic>.filled(42, null).toList();
  Expect.equals(42, a.length);
  a.add(499);
  Expect.equals(43, a.length);
  Expect.equals(499, a[42]);
  Expect.equals(null, a[23]);
  a.clear();
  Expect.equals(0, a.length);
  Expect.throwsRangeError(() => a[0]);

  a = new List<int>.filled(42, null).toList();
  Expect.equals(42, a.length);
  a.add(499);
  Expect.equals(43, a.length);
  Expect.equals(499, a[42]);
  for (int i = 0; i < 42; i++) {
    Expect.equals(null, a[i]);
  }
  a.clear();
  Expect.equals(0, a.length);
  Expect.throwsRangeError(() => a[0]);
}
