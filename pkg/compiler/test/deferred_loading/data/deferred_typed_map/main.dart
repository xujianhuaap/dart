// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*library: 
 a_pre_fragments=[p1: {units: [1{lib}], usedBy: [], needs: []}],
 b_finalized_fragments=[f1: [1{lib}]],
 c_steps=[lib=(f1)]
*/

import 'lib1.dart' deferred as lib;

/*member: main:
 constants=[MapConstant(<int, dynamic Function({M b})>{IntConstant(1): FunctionConstant(f1), IntConstant(2): FunctionConstant(f2)})=1{lib}],
 member_unit=main{}
*/
main() async {
  await lib.loadLibrary();
  print(lib.table[1]);
}
