// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

main() {
  print(const Class1().field1);
  print(const Class2(field2: true).field2);
  print(const Class3().field3);
  print(const Class3(field3: true).field3);
}

class Class1 {
  /*member: Class1.field1:constant=BoolConstant(false)*/
  final bool field1;

  const Class1({this.field1 = false});
}

class Class2 {
  /*spec.member: Class2.field2:constant=BoolConstant(true)*/
  final bool field2;

  const Class2({this.field2 = false});
}

class Class3 {
  final bool field3;

  const Class3({this.field3 = false});
}
