// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// VMOptions=--enable-asserts
// dart2jsOptions=--enable-asserts
// dart2wasmOptions=--enable-asserts

// Dart test program testing assert statements.

import "package:expect/expect.dart";

int testTrue() {
  int i = 0;
  try {
    assert(true);
  } on AssertionError {
    i = 1;
  }
  return i;
}

int testFalse() {
  int i = 0;
  try {
    assert(false);
  } on AssertionError {
    i = 1;
  }
  return i;
}

unknown(dynamic a) {
  return a ? true : false;
}

int testBoolean(bool value) {
  int i = 0;
  try {
    assert(value);
  } on AssertionError {
    i = 1;
  }
  return i;
}

int testDynamic(dynamic value) {
  int i = 0;
  try {
    assert(value);
  } on AssertionError {
    i = 1;
  }
  return i;
}

int testImmediatelyInvokedFunctionExpression(bool value) {
  int i = 0;
  try {
    assert((() => value)());
  } on AssertionError {
    i = 1;
  }
  return i;
}

testMessage(value, message) {
  try {
    assert(value, message);
    return null;
  } on AssertionError catch (error) {
    return error;
  }
  return null;
}

main() {
  Expect.equals(0, testTrue());
  Expect.equals(0, testBoolean(true));
  Expect.equals(0, testDynamic(unknown(true)));
  Expect.equals(0, testImmediatelyInvokedFunctionExpression(true));

  Expect.equals(1, testFalse());
  Expect.equals(1, testBoolean(false));
  Expect.equals(1, testDynamic(unknown(false)));
  Expect.equals(1, testImmediatelyInvokedFunctionExpression(false));

  Expect.throwsTypeError(() => testDynamic(null));
  Expect.throwsTypeError(() => testDynamic(42));
  Expect.throwsTypeError(() => testDynamic(() => true));
  Expect.throwsTypeError(() => testDynamic(() => false));
  Expect.throwsTypeError(() => testDynamic(() => 42));
  Expect.throwsTypeError(() => testDynamic(() => null));

  Expect.equals(1234, testMessage(false, 1234).message);
  Expect.equals('hi', testMessage(false, 'hi').message);

  // These assertions throw a type error because boolean conversion failed.
  Expect.throwsTypeError(() => testMessage(null, 1234));
  Expect.throwsTypeError(() => testMessage(null, 'hi'));
  Expect.throwsTypeError(() => testMessage(() => null, 'hi'));
  Expect.throwsTypeError(() => testMessage(() => false, 'hi'));
  Expect.throwsTypeError(() => testMessage(() => true, 'hi'));
}
