// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

// Regression test for dart2js that used to statically inline the length of an
// array held in a variable when it could, even if that variable could
// be null.

import "package:expect/expect.dart";

var list;

main() {
  if (new DateTime.now().millisecondsSinceEpoch == 0)
    list = new List.filled(4, null);
  Expect.throwsNoSuchMethodError(() => print(list[5]));
}
