// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*@testedFeatures=inference*/
library test;

class A {
  int f = 0;
}

A a = new A();
var b = (a. /*@target=A.f*/ f = 1);
var c = 0;
var d = (c = 1);

main() {
  a;
  b;
  c;
  d;
}
