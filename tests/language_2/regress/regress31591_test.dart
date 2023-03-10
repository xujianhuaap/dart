// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

// VMOptions=--optimization-counter-threshold=90

import 'package:expect/expect.dart';

typedef FunObjObj = Object Function<T>(Object, {Object y});

Object funTypObj<T>(T x, {Object y}) => y;

main() {
  for (int i = 0; i < 100; i++) {
    Expect.throwsTypeError(() {
      dynamic y = funTypObj;
      final FunObjObj x2 = y;
    });
  }
}
