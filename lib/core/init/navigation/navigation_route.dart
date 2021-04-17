import 'package:engelsiz_yollar/core/components/cards/not_found_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../view/auth/login/view/login_view.dart';
import '../../constants/navigation/navigation_constans.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> onGenerateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.LOGIN_VIEW:
      return normalNavigate(LoginView());
      
        break;
      default:
      return MaterialPageRoute(builder: (_) => NotFoundNavigation());
    }    
  }

  MaterialPageRoute normalNavigate(Widget widget){
    return MaterialPageRoute(builder: (_) => widget);
  }


}
