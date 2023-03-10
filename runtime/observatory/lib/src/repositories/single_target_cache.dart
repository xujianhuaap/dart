// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file

part of repositories;

class SingleTargetCacheRepository extends M.SingleTargetCacheRepository {
  Future<M.SingleTargetCache> get(M.IsolateRef i, String id) async {
    S.Isolate isolate = i as S.Isolate;
    return (await isolate.getObject(id)) as S.SingleTargetCache;
  }
}
