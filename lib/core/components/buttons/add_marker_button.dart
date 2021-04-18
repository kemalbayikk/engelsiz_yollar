import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class AddMarkerButton extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  final Color color;

  const AddMarkerButton(
      {Key key, this.onTap, @required this.child, this.color = Colors.red})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: context.paddingLow,
        margin: context.paddingLow,
        decoration: BoxDecoration(
          color: color,
          borderRadius: 0.radius10,
          boxShadow: AppConstants.shadow_1,
        ),
        child: child,
      ),
    );
  }
}
