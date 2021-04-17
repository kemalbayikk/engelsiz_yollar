import 'package:flutter/material.dart';

abstract class INavigationService {
  Future navigateToPage({@required String path, Object data});
  Future navigateToPageClear({@required String path, Object data});
  Future get navPop;
  bool get canPop;
}
