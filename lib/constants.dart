import 'package:flutter/material.dart';

class Constants{
  static const String baseUri = 'https://api.mazoboothmirror.com/';
  static const String domain = '${baseUri}api/';
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  static const int mirrorId = 1;


  static BuildContext globalContext(){
    return navState.currentContext!;
  }
}

