// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:observatory/models.dart' as M;
import 'package:observatory/src/elements/helpers/any_ref.dart';
import 'package:observatory/src/elements/helpers/nav_bar.dart';
import 'package:observatory/src/elements/helpers/nav_menu.dart';
import 'package:observatory/src/elements/helpers/rendering_scheduler.dart';
import 'package:observatory/src/elements/helpers/custom_element.dart';
import 'package:observatory/src/elements/nav/isolate_menu.dart';
import 'package:observatory/src/elements/nav/notify.dart';
import 'package:observatory/src/elements/nav/refresh.dart';
import 'package:observatory/src/elements/nav/top_menu.dart';
import 'package:observatory/src/elements/nav/vm_menu.dart';
import 'package:observatory/src/elements/object_common.dart';

class UnlinkedCallViewElement extends CustomElement implements Renderable {
  late RenderingScheduler<UnlinkedCallViewElement> _r;

  Stream<RenderedEvent<UnlinkedCallViewElement>> get onRendered =>
      _r.onRendered;

  late M.VM _vm;
  late M.IsolateRef _isolate;
  late M.EventRepository _events;
  late M.NotificationRepository _notifications;
  late M.UnlinkedCall _unlinkedcall;
  late M.UnlinkedCallRepository _unlinkedcalls;
  late M.RetainedSizeRepository _retainedSizes;
  late M.ReachableSizeRepository _reachableSizes;
  late M.InboundReferencesRepository _references;
  late M.RetainingPathRepository _retainingPaths;
  late M.ObjectRepository _objects;

  M.VMRef get vm => _vm;
  M.IsolateRef get isolate => _isolate;
  M.NotificationRepository get notifications => _notifications;
  M.UnlinkedCall get unlinkedcall => _unlinkedcall;

  factory UnlinkedCallViewElement(
      M.VM vm,
      M.IsolateRef isolate,
      M.UnlinkedCall unlinkedcall,
      M.EventRepository events,
      M.NotificationRepository notifications,
      M.UnlinkedCallRepository unlinkedcalls,
      M.RetainedSizeRepository retainedSizes,
      M.ReachableSizeRepository reachableSizes,
      M.InboundReferencesRepository references,
      M.RetainingPathRepository retainingPaths,
      M.ObjectRepository objects,
      {RenderingQueue? queue}) {
    UnlinkedCallViewElement e = new UnlinkedCallViewElement.created();
    e._r = new RenderingScheduler<UnlinkedCallViewElement>(e, queue: queue);
    e._vm = vm;
    e._isolate = isolate;
    e._events = events;
    e._notifications = notifications;
    e._unlinkedcall = unlinkedcall;
    e._unlinkedcalls = unlinkedcalls;
    e._retainedSizes = retainedSizes;
    e._reachableSizes = reachableSizes;
    e._references = references;
    e._retainingPaths = retainingPaths;
    e._objects = objects;
    return e;
  }

  UnlinkedCallViewElement.created() : super.created('unlinkedcall-view');

  @override
  attached() {
    super.attached();
    _r.enable();
  }

  @override
  detached() {
    super.detached();
    _r.disable(notify: true);
    children = <Element>[];
  }

  void render() {
    children = <Element>[
      navBar(<Element>[
        new NavTopMenuElement(queue: _r.queue).element,
        new NavVMMenuElement(_vm, _events, queue: _r.queue).element,
        new NavIsolateMenuElement(_isolate, _events, queue: _r.queue).element,
        navMenu('unlinkedcall'),
        (new NavRefreshElement(queue: _r.queue)
              ..onRefresh.listen((e) async {
                e.element.disabled = true;
                _unlinkedcall =
                    await _unlinkedcalls.get(_isolate, _unlinkedcall.id!);
                _r.dirty();
              }))
            .element,
        new NavNotifyElement(_notifications, queue: _r.queue).element
      ]),
      new DivElement()
        ..classes = ['content-centered-big']
        ..children = <Element>[
          new HeadingElement.h2()..text = 'UnlinkedCall',
          new HRElement(),
          new ObjectCommonElement(_isolate, _unlinkedcall, _retainedSizes,
                  _reachableSizes, _references, _retainingPaths, _objects,
                  queue: _r.queue)
              .element,
          new DivElement()
            ..classes = ['memberList']
            ..children = <Element>[
              new DivElement()
                ..classes = ['memberItem']
                ..children = <Element>[
                  new DivElement()
                    ..classes = ['memberName']
                    ..text = 'selector',
                  new DivElement()
                    ..classes = ['memberName']
                    ..text = _unlinkedcall.selector
                ],
              new DivElement()
                ..classes = ['memberItem']
                ..children = <Element>[
                  new DivElement()
                    ..classes = ['memberName']
                    ..text = 'argumentsDescriptor',
                  new DivElement()
                    ..classes = ['memberName']
                    ..children = <Element>[
                      _unlinkedcall.argumentsDescriptor == null
                          ? (new SpanElement()..text = '<none>')
                          : anyRef(_isolate, _unlinkedcall.argumentsDescriptor,
                              _objects,
                              queue: _r.queue)
                    ]
                ]
            ],
        ]
    ];
  }
}
