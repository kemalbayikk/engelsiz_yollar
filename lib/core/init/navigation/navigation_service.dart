import 'package:flutter/cupertino.dart';

import 'INavigationService.dart';

class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;

  NavigationService._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final removeAllRoutes = (Route<dynamic> route) => false;
  @override
  Future navigateToPage({@required String path, Object data}) async {
      await navigatorKey.currentState.pushNamed(path, arguments: data);
    }
  
    @override
    Future navigateToPageClear( {@required String path, Object data}) async {
    await navigatorKey.currentState.pushNamedAndRemoveUntil(path,removeAllRoutes, arguments: data);
  }

  @override
  Future get navPop async => navigatorKey.currentState.pop();

  @override
  
  bool get canPop => navigatorKey.currentState.canPop();

  
}
