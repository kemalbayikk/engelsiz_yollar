import 'package:flutter/material.dart';

import '../../constants/app/app_constants.dart';
import '../../extensions/num_extensions.dart';

class MyButton extends StatelessWidget {
  final Widget child;

  const MyButton({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.paddingAll,
      margin: [5, 10].paddingSymmetric,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: 0.radius10,
        boxShadow: AppConstants.shadow_1,
      ),
      child: child,
    );
  }
}
