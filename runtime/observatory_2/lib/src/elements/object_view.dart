// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:observatory_2/models.dart' as M;
import 'package:observatory_2/src/elements/helpers/nav_bar.dart';
import 'package:observatory_2/src/elements/helpers/nav_menu.dart';
import 'package:observatory_2/src/elements/helpers/rendering_scheduler.dart';
import 'package:observatory_2/src/elements/helpers/custom_element.dart';
import 'package:observatory_2/src/elements/nav/isolate_menu.dart';
import 'package:observatory_2/src/elements/nav/notify.dart';
import 'package:observatory_2/src/elements/nav/refresh.dart';
import 'package:observatory_2/src/elements/nav/top_menu.dart';
import 'package:observatory_2/src/elements/nav/vm_menu.dart';
import 'package:observatory_2/src/elements/object_common.dart';

class ObjectViewElement extends CustomElement implements Renderable {
  RenderingScheduler<ObjectViewElement> _r;

  Stream<RenderedEvent<ObjectViewElement>> get onRendered => _r.onRendered;

  M.VM _vm;
  M.IsolateRef _isolate;
  M.EventRepository _events;
  M.NotificationRepository _notifications;
  M.Object _object;
  M.ObjectRepository _objects;
  M.RetainedSizeRepository _retainedSizes;
  M.ReachableSizeRepository _reachableSizes;
  M.InboundReferencesRepository _references;
  M.RetainingPathRepository _retainingPaths;

  M.VMRef get vm => _vm;
  M.IsolateRef get isolate => _isolate;
  M.NotificationRepository get notifications => _notifications;
  M.Context get object => _object;

  factory ObjectViewElement(
      M.VM vm,
      M.IsolateRef isolate,
      M.Object object,
      M.EventRepository events,
      M.NotificationRepository notifications,
      M.ObjectRepository objects,
      M.RetainedSizeRepository retainedSizes,
      M.ReachableSizeRepository reachableSizes,
      M.InboundReferencesRepository references,
      M.RetainingPathRepository retainingPaths,
      {RenderingQueue queue}) {
    assert(vm != null);
    assert(isolate != null);
    assert(events != null);
    assert(notifications != null);
    assert(object != null);
    assert(objects != null);
    assert(retainedSizes != null);
    assert(reachableSizes != null);
    assert(references != null);
    assert(retainingPaths != null);
    ObjectViewElement e = new ObjectViewElement.created();
    e._r = new RenderingScheduler<ObjectViewElement>(e, queue: queue);
    e._vm = vm;
    e._isolate = isolate;
    e._events = events;
    e._notifications = notifications;
    e._object = object;
    e._objects = objects;
    e._retainedSizes = retainedSizes;
    e._reachableSizes = reachableSizes;
    e._references = references;
    e._retainingPaths = retainingPaths;
    return e;
  }

  ObjectViewElement.created() : super.created('object-view');

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
        navMenu('object'),
        (new NavRefreshElement(queue: _r.queue)
              ..onRefresh.listen((e) async {
                e.element.disabled = true;
                _object = await _objects.get(_isolate, _object.id);
                _r.dirty();
              }))
            .element,
        new NavNotifyElement(_notifications, queue: _r.queue).element
      ]),
      new DivElement()
        ..classes = ['content-centered-big']
        ..children = <Element>[
          new HeadingElement.h2()..text = 'Object',
          new HRElement(),
          new ObjectCommonElement(_isolate, _object, _retainedSizes,
                  _reachableSizes, _references, _retainingPaths, _objects,
                  queue: _r.queue)
              .element,
        ]
    ];
  }
}
