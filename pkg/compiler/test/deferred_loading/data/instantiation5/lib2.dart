// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*member: getFoo:member_unit=3{c}*/
T getFoo<T>(T v) => v;

typedef dynamic G<T>(T v);

/*member: m:
 constants=[InstantiationConstant([int],FunctionConstant(getFoo))=3{c}],
 member_unit=3{c}
*/
m(int x, {G<int>? f}) {
  f ??= getFoo;
  print(f(x));
}
