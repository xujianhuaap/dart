// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#ifndef RUNTIME_VM_HEAP_WEAK_CODE_H_
#define RUNTIME_VM_HEAP_WEAK_CODE_H_

#include "vm/allocation.h"
#include "vm/globals.h"

namespace dart {

class WeakArray;
class Code;

// Helper class to handle an array of code weak properties. Implements
// registration and disabling of stored code objects.
class WeakCodeReferences : public ValueObject {
 public:
  explicit WeakCodeReferences(const WeakArray& value) : array_(value) {}
  virtual ~WeakCodeReferences() {}

  void Register(const Code& value);

  virtual void UpdateArrayTo(const WeakArray& array) = 0;
  virtual void ReportDeoptimization(const Code& code) = 0;
  virtual void ReportSwitchingCode(const Code& code) = 0;

  void DisableCode(bool are_mutators_stopped);

  bool HasCodes() const;

 private:
  const WeakArray& array_;  // Array of Code objects.
  DISALLOW_COPY_AND_ASSIGN(WeakCodeReferences);
};

}  // namespace dart

#endif  // RUNTIME_VM_HEAP_WEAK_CODE_H_
