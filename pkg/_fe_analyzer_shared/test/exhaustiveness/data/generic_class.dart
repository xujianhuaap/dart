// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class A<X> {}

switchADynamic(A<dynamic> o) {
  var a = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<dynamic>
  */
  switch (o) {
    A() /*space=A<dynamic>*/=> 0,
  };
  var b = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<dynamic>
  */
  switch (o) {
    A<dynamic>() /*space=A<dynamic>*/=> 0,
  };
}

switchANum(A<num> o) {
  var a = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<num>
  */
  switch (o) {
    A() /*space=A<num>*/=> 0,
  };
  var b = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<num>
  */
  switch (o) {
    A<dynamic>() /*cfe.space=A<num>*//*analyzer.space=A<dynamic>*/=> 0,
  };
  var c = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<num>
  */
  switch (o) {
    A<num>() /*space=A<num>*/=> 0,
  };
  var d1 = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<num>
  */
  switch (o) {
    A<int>() /*space=A<int>*/=> 0,
    _ /*space=()*/=> 1,
  };
  var d2 = /*
   error=non-exhaustive:A<num>,
   fields={hashCode:int,runtimeType:Type},
   type=A<num>
  */
  switch (o) {
    A<int>() /*space=A<int>*/=> 0,
  };
}

switchAGeneric<T>(A<T> o) {
  var a = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<T>
  */
  switch (o) {
    A() /*space=A<T>*/=> 0,
  };
  var b = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<T>
  */
  switch (o) {
    A<dynamic>() /*cfe.space=A<T>*//*analyzer.space=A<dynamic>*/=> 0,
  };
  var c = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<T>
  */
  switch (o) {
    A<T>() /*space=A<T>*/=> 0,
  };
  var d1 = /*
   fields={hashCode:int,runtimeType:Type},
   type=A<T>
  */
  switch (o) {
    A<int>() /*space=A<int>*/=> 0,
    _ /*space=()*/=> 1,
  };
  var d2 = /*
   error=non-exhaustive:A<T>,
   fields={hashCode:int,runtimeType:Type},
   type=A<T>
  */
  switch (o) {
    A<int>() /*space=A<int>*/=> 0,
  };
}