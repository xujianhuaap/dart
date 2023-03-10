// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

import "package:expect/expect.dart";

main() {
  var list = [];
  list.setRange(0, 0, const []);
  list.setRange(0, 0, []);
  list.setRange(0, 0, const [], 1);
  list.setRange(0, 0, [], 1);
  Expect.equals(0, list.length);
  Expect.throwsRangeError(() => list.setRange(0, 1, []));
  Expect.throwsRangeError(() => list.setRange(0, 1, [], 1));
  Expect.throwsRangeError(() => list.setRange(0, 1, [1], 0));

  list.add(1);
  list.setRange(0, 0, [], 0);
  Expect.equals(1, list.length);
  Expect.equals(1, list[0]);
  list.setRange(0, 0, const [], 0);
  Expect.equals(1, list.length);
  Expect.equals(1, list[0]);

  Expect.throwsRangeError(() => list.setRange(0, 2, [1, 2]));
  Expect.equals(1, list.length);
  Expect.equals(1, list[0]);

  Expect.throwsStateError(() => list.setRange(0, 1, [1, 2], 2));
  Expect.equals(1, list.length);
  Expect.equals(1, list[0]);

  list.setRange(0, 1, [2], 0);
  Expect.equals(1, list.length);
  Expect.equals(2, list[0]);

  list.setRange(0, 1, const [3], 0);
  Expect.equals(1, list.length);
  Expect.equals(3, list[0]);

  list.addAll([4, 5, 6]);
  Expect.equals(4, list.length);
  list.setRange(0, 4, [1, 2, 3, 4]);
  Expect.listEquals([1, 2, 3, 4], list);

  list.setRange(2, 4, [5, 6, 7, 8]);
  Expect.listEquals([1, 2, 5, 6], list);

  Expect.throwsRangeError(() => list.setRange(4, 5, [5, 6, 7, 8]));
  Expect.listEquals([1, 2, 5, 6], list);

  list.setRange(1, 3, [9, 10, 11, 12]);
  Expect.listEquals([1, 9, 10, 6], list);

  testNegativeIndices();

  testNonExtendableList();
}

void testNegativeIndices() {
  var list = [1, 2];
  Expect.throwsRangeError(() => list.setRange(-1, 1, [1]));
  Expect.throwsArgumentError(() => list.setRange(0, 1, [1], -1));

  Expect.throwsRangeError(() => list.setRange(2, 1, [1]));

  Expect.throwsArgumentError(() => list.setRange(-1, -2, [1], -1));
  Expect.listEquals([1, 2], list);

  Expect.throwsRangeError(() => list.setRange(-1, -1, [1]));
  Expect.listEquals([1, 2], list);

  // The skipCount is only used if the length is not 0.
  list.setRange(0, 0, [1], -1);
  Expect.listEquals([1, 2], list);
}

void testNonExtendableList() {
  var list = new List<int>.filled(6, null);
  Expect.listEquals([null, null, null, null, null, null], list);
  list.setRange(0, 3, [1, 2, 3, 4]);
  list.setRange(3, 6, [1, 2, 3, 4]);
  Expect.listEquals([1, 2, 3, 1, 2, 3], list);
}
