// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:expect/expect.dart';

import 'dart:collection';

class Foo<T> {}

const f1 = Foo<Queue>.new;
const f2 = Foo<Queue<String>>.new;

main() {
  Expect.type<Foo<Iterable>>(f1());
  Expect.type<Foo<Iterable<Comparable>>>(f2());
}
