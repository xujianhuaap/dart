// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.7

/*prod.class: global#Map:*/
/*spec.class: global#Map:explicit=[Map,Map<Object?,Object?>,void Function(Map.K,Map.V)],needsArgs,test*/

/*prod.class: global#LinkedHashMap:deps=[Map]*/
/*spec.class: global#LinkedHashMap:deps=[Map],explicit=[LinkedHashMap<LinkedHashMap.K,LinkedHashMap.V>],implicit=[LinkedHashMap.K,LinkedHashMap.V],needsArgs,test*/

/*prod.class: global#JsLinkedHashMap:deps=[LinkedHashMap]*/
/*spec.class: global#JsLinkedHashMap:deps=[LinkedHashMap],explicit=[JsLinkedHashMap,JsLinkedHashMap.K,JsLinkedHashMap.V,void Function(JsLinkedHashMap.K,JsLinkedHashMap.V)],implicit=[JsLinkedHashMap.K],needsArgs,test*/

/*prod.class: global#double:*/
/*spec.class: global#double:implicit=[double]*/

/*class: global#JSNumNotInt:*/

main() {
  <int, double>{}[0] = 0.5;
}
