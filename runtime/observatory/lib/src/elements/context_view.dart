// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'package:observatory/models.dart' as M;
import 'package:observatory/src/elements/context_ref.dart';
import 'package:observatory/src/elements/curly_block.dart';
import 'package:observatory/src/elements/helpers/any_ref.dart';
import 'package:observatory/src/elements/helpers/nav_bar.dart';
import 'package:observatory/src/elements/helpers/nav_menu.dart';
import 'package:observatory/src/elements/helpers/rendering_scheduler.dart';
import 'package:observatory/src/elements/helpers/custom_element.dart';
import 'package:observatory/src/elements/nav/class_menu.dart';
import 'package:observatory/src/elements/nav/isolate_menu.dart';
import 'package:observatory/src/elements/nav/notify.dart';
import 'package:observatory/src/elements/nav/refresh.dart';
import 'package:observatory/src/elements/nav/top_menu.dart';
import 'package:observatory/src/elements/nav/vm_menu.dart';
import 'package:observatory/src/elements/object_common.dart';

class ContextViewElement extends CustomElement implements Renderable {
  late RenderingScheduler<ContextViewElement> _r;

  Stream<RenderedEvent<ContextViewElement>> get onRendered => _r.onRendered;

  late M.VM _vm;
  late M.IsolateRef _isolate;
  late M.EventRepository _events;
  late M.NotificationRepository _notifications;
  late M.Context _context;
  late M.ContextRepository _contexts;
  late M.RetainedSizeRepository _retainedSizes;
  late M.ReachableSizeRepository _reachableSizes;
  late M.InboundReferencesRepository _references;
  late M.RetainingPathRepository _retainingPaths;
  late M.ObjectRepository _objects;

  M.VMRef get vm => _vm;
  M.IsolateRef get isolate => _isolate;
  M.NotificationRepository get notifications => _notifications;
  M.Context get context => _context;

  factory ContextViewElement(
      M.VM vm,
      M.IsolateRef isolate,
      M.Context context,
      M.EventRepository events,
      M.NotificationRepository notifications,
      M.ContextRepository contexts,
      M.RetainedSizeRepository retainedSizes,
      M.ReachableSizeRepository reachableSizes,
      M.InboundReferencesRepository references,
      M.RetainingPathRepository retainingPaths,
      M.ObjectRepository objects,
      {RenderingQueue? queue}) {
    ContextViewElement e = new ContextViewElement.created();
    e._r = new RenderingScheduler<ContextViewElement>(e, queue: queue);
    e._vm = vm;
    e._isolate = isolate;
    e._events = events;
    e._notifications = notifications;
    e._context = context;
    e._contexts = contexts;
    e._retainedSizes = retainedSizes;
    e._reachableSizes = reachableSizes;
    e._references = references;
    e._retainingPaths = retainingPaths;
    e._objects = objects;
    return e;
  }

  ContextViewElement.created() : super.created('context-view');

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
    var content = <Element>[
      navBar(<Element>[
        new NavTopMenuElement(queue: _r.queue).element,
        new NavVMMenuElement(_vm, _events, queue: _r.queue).element,
        new NavIsolateMenuElement(_isolate, _events, queue: _r.queue).element,
        new NavClassMenuElement(_isolate, _context.clazz!, queue: _r.queue)
            .element,
        navMenu('instance'),
        (new NavRefreshElement(queue: _r.queue)
              ..onRefresh.listen((e) async {
                e.element.disabled = true;
                _context = await _contexts.get(_isolate, _context.id!);
                _r.dirty();
              }))
            .element,
        new NavNotifyElement(_notifications, queue: _r.queue).element
      ]),
      new DivElement()
        ..classes = ['content-centered-big']
        ..children = <Element>[
          new HeadingElement.h2()..text = 'Context',
          new HRElement(),
          new ObjectCommonElement(_isolate, _context, _retainedSizes,
                  _reachableSizes, _references, _retainingPaths, _objects,
                  queue: _r.queue)
              .element
        ]
    ];
    if (_context.parentContext != null) {
      content.addAll([
        new BRElement(),
        new DivElement()
          ..classes = ['content-centered-big']
          ..children = <Element>[
            new DivElement()
              ..classes = ['memberList']
              ..children = <Element>[
                new DivElement()
                  ..classes = ['memberItem']
                  ..children = <Element>[
                    new DivElement()
                      ..classes = ['memberName']
                      ..text = 'parent context',
                    new DivElement()
                      ..classes = ['memberName']
                      ..children = <Element>[
                        new ContextRefElement(
                                _isolate, _context.parentContext!, _objects,
                                queue: _r.queue)
                            .element
                      ]
                  ]
              ]
          ]
      ]);
    }
    content.add(new HRElement());
    if (_context.variables!.isNotEmpty) {
      int index = 0;
      content.addAll([
        new DivElement()
          ..classes = ['content-centered-big']
          ..children = <Element>[
            new SpanElement()..text = 'Variables ',
            (new CurlyBlockElement(expanded: true, queue: _r.queue)
                  ..content = <Element>[
                    new DivElement()
                      ..classes = ['memberList']
                      ..children = _context.variables!
                          .map<Element>((variable) => new DivElement()
                            ..classes = ['memberItem']
                            ..children = <Element>[
                              new DivElement()
                                ..classes = ['memberName']
                                ..text = '[ ${++index} ]',
                              new DivElement()
                                ..classes = ['memberName']
                                ..children = <Element>[
                                  anyRef(_isolate, variable.value, _objects,
                                      queue: _r.queue)
                                ]
                            ])
                          .toList()
                  ])
                .element
          ]
      ]);
    }
    children = content;
  }
}
