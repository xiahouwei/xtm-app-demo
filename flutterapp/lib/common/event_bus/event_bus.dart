import 'dart:async';

import 'package:event_bus/event_bus.dart';

import 'event_bus_type.dart';

class EventBusData {
  final EventBusType type;
  final dynamic data;

  EventBusData(this.type, {this.data});
}

class XtmEventBus {
  static final XtmEventBus _singleton = XtmEventBus._internal();

  factory XtmEventBus() => _singleton;
  final EventBus _bus;

  XtmEventBus._internal() : _bus = EventBus();

  void fire(EventBusType type, {dynamic data}) {
    _bus.fire(EventBusData(type, data: data));
  }

  StreamSubscription on(EventBusType type, void Function(dynamic data) handler) {
    return _bus.on<EventBusData>().listen((event) {
      if (event.type == type) {
        handler(event.data);
      }
    });
  }
}

final eventBus = XtmEventBus();
