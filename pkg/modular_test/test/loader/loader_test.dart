// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Tests that the logic to load, parse, and validate modular tests.
import 'dart:io';

import 'package:test/test.dart';
import 'package:modular_test/src/loader.dart';
import 'package:modular_test/src/suite.dart';

import 'package:args/args.dart';

main(List<String> args) async {
  var options = _Options.parse(args);
  var baseUri = Platform.script.resolve('./');
  var baseDir = Directory.fromUri(baseUri);
  await for (var entry in baseDir.list(recursive: false)) {
    if (entry is Directory) {
      var dirName = entry.uri.path.substring(baseDir.path.length);
      test(dirName, () => _runTest(entry.uri, dirName, options),
          skip: options.filter != null && !dirName.contains(options.filter));
    }
  }
}

Future<void> _runTest(Uri uri, String dirName, _Options options) async {
  String result;
  String header =
      "# This expectation file is generated by loader_test.dart\n\n";
  try {
    ModularTest test = await loadTest(uri);
    result = '$header${_dumpAsText(test)}';
  } on Error catch (e) {
    result = '$header$e';
  }

  var file = File.fromUri(uri.resolve('expectation.txt'));
  if (!options.updateExpectations) {
    expect(await file.exists(), isTrue,
        reason: "expectation.txt file is missing");
    var expectation = await file.readAsString();
    if (expectation != result) {
      print("expectation.txt doesn't match the result of the test. "
          "To update it, run:\n"
          "   ${Platform.executable} ${Platform.script} "
          "--update --show-update --filter $dirName");
    }
    expect(expectation, result);
  } else if (await file.exists() && (await file.readAsString() == result)) {
    print("  expectation matches result and was up to date.");
  } else {
    await file.writeAsString(result);
    print("  updated ${file.uri}");
    if (options.showResultOnUpdate) {
      print('  new expectation is:\x1b[32m\n$result\x1b[0m');
    }
  }
}

String _dumpAsText(ModularTest test) {
  var buffer = new StringBuffer();
  bool isFirst = true;
  for (var module in test.modules) {
    if (isFirst) {
      isFirst = false;
    } else {
      buffer.write('\n');
    }
    buffer.write(module.name);
    if (module.isMain) {
      expect(test.mainModule, module);
      buffer.write('\n  **main module**');
    }
    buffer.write('\n  is package? ${module.isPackage ? 'yes' : 'no'}');
    buffer.write('\n  is shared?  ${module.isShared ? 'yes' : 'no'}');
    buffer.write('\n  is sdk?  ${module.isSdk ? 'yes' : 'no'}');
    if (module.dependencies.isEmpty) {
      buffer.write('\n  (no dependencies)');
    } else {
      buffer.write('\n  dependencies: '
          '${module.dependencies.map((d) => d.name).join(", ")}');
    }

    if (module.sources.isEmpty) {
      buffer.write('\n  (no sources)');
    } else if (module.isSdk) {
      buffer.write('\n  (sdk sources omitted)');
    } else {
      module.sources.forEach((uri) {
        buffer.write('\n  $uri');
      });
    }

    buffer.write('\n');
  }
  return '$buffer';
}

class _Options {
  bool updateExpectations = false;
  bool showResultOnUpdate = false;
  String filter = null;

  static _Options parse(List<String> args) {
    var parser = new ArgParser()
      ..addFlag('update',
          abbr: 'u',
          defaultsTo: false,
          help: "update expectation files if the result don't match")
      ..addFlag('show-update',
          defaultsTo: false,
          help: "print the result when updating expectation files")
      ..addFlag('show-skipped',
          defaultsTo: false,
          help: "print the name of the tests skipped by the filtering option")
      ..addOption('filter',
          help: "only run tests containing this filter as a substring");
    ArgResults argResults = parser.parse(args);
    return _Options()
      ..updateExpectations = argResults['update']
      ..showResultOnUpdate = argResults['show-update']
      ..filter = argResults['filter'];
  }
}
