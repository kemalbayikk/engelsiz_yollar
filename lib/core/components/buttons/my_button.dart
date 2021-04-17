import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget child;

  const MyButton({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.paddingAll,
      margin: [5, 10].paddingSymmetric,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: 0.radius10,
        boxShadow: AppConstants.shadow_1,
      ),
      child: child,
    );
  }
}
