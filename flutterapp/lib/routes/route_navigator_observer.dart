import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteNavigatorObserver extends NavigatorObserver {
  RouteNavigatorObserver._internal();

  static final RouteNavigatorObserver _instance = RouteNavigatorObserver._internal();

  factory RouteNavigatorObserver() => _instance;

  List<Route> _routes = [];

  Route<dynamic> get currentRoute => _getCurrentRoute();

  String get currentRouteName {
    if (currentRoute == null) return null;
    return currentRoute.settings.name;
  }

  List<Route> get routes => _routes;

  Route _getCurrentRoute() {
    if (_routes.isEmpty) return null;
    return _routes.last;
  }

  @override
  void didPush(Route route, Route previousRoute) {
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _routes.add(route);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    if (newRoute is CupertinoPageRoute || newRoute is MaterialPageRoute) {
      _routes.remove(oldRoute);
      _routes.add(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _routes.remove(route);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _routes.remove(route);
    }
    super.didRemove(route, previousRoute);
  }
}
