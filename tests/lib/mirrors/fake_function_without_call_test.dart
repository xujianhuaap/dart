// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(51557): Decide if the mixins being applied in this test should be
// "mixin", "mixin class" or the test should be left at 2.19.
// @dart=2.19

import "dart:mirrors";

import "package:expect/expect.dart";

class MultiArityFunction implements Function {
  noSuchMethod(Invocation msg) {
    if (msg.memberName != #call) return super.noSuchMethod(msg);
    return msg.positionalArguments.join(",");
  }
}

main() {
  dynamic f = new MultiArityFunction();

  Expect.isTrue(f is Function);
  Expect.equals('a', f('a'));
  Expect.equals('a,b', f('a', 'b'));
  Expect.equals('a,b,c', f('a', 'b', 'c'));
  Expect.equals('a', Function.apply(f, ['a']));
  Expect.equals('a,b', Function.apply(f, ['a', 'b']));
  Expect.equals('a,b,c', Function.apply(f, ['a', 'b', 'c']));
  Expect.throwsNoSuchMethodError(() => f.foo('a', 'b', 'c'));

  ClosureMirror cm = reflect(f) as ClosureMirror;
  Expect.isTrue(cm is ClosureMirror);
  Expect.equals('a', cm.apply(['a']).reflectee);
  Expect.equals('a,b', cm.apply(['a', 'b']).reflectee);
  Expect.equals('a,b,c', cm.apply(['a', 'b', 'c']).reflectee);

  MethodMirror mm = cm.function;
  Expect.isNull(mm);

  ClassMirror km = cm.type;
  Expect.equals(reflectClass(MultiArityFunction), km);
}
