// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*@testedFeatures=inference*/
library test;

T f<T>() => throw '';

class C implements B {
  final x;
  C() : x = /*@typeArgs=int*/ f();
}

abstract class B {
  int get x;
}

main() {}
