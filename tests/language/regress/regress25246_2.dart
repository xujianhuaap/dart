// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'regress25246_3.dart';

mixin MixIn {
  var test3 = new Test3(() {});
  void test() {
    test3.test();
  }
}
