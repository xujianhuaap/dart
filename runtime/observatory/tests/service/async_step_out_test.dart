// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// VMOptions=--async-debugger --verbose-debug

import 'dart:developer';
import 'service_test_common.dart';
import 'test_helper.dart';

const LINE_A = 19;
const LINE_B = 20;
const LINE_C = 21;
const LINE_D = 26;
const LINE_E = 27;
const LINE_F = 28;

helper() async {
  await null; // LINE_A.
  print('helper'); // LINE_B.
  print('foobar'); // LINE_C.
}

testMain() async {
  debugger();
  print('mmmmm'); // LINE_D.
  await helper(); // LINE_E.
  print('z'); // LINE_F.
}

var tests = <IsolateTest>[
  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_D),
  stepOver, // print.

  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_E),
  stepInto,

  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_A),
  asyncNext,

  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_B),
  stepOver, // print.

  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_C),
  stepOut, // out of helper to awaiter testMain.

  hasStoppedAtBreakpoint,
  stoppedAtLine(LINE_F),
];

main(args) => runIsolateTests(args, tests,
    testeeConcurrent: testMain, extraArgs: extraDebuggingArgs);
