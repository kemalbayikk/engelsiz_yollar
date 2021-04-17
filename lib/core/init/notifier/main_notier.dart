import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainNotifier with ChangeNotifier, DiagnosticableTreeMixin {
  var _page = 0;

  int get getPage => _page;

  void changePage(int page) {
    _page = page;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('page', getPage));
  }
}
