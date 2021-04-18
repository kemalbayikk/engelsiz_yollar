import 'package:flutter/material.dart';

import '../../constants/app/app_constants.dart';
import '../../extensions/num_extensions.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final Alignment align;
  final Color color;

  const MyCard({Key key, this.child, this.align = Alignment.center, this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: 10.paddingAll,
      margin: 5.paddingAll,
      decoration: BoxDecoration(
        color: color,
        boxShadow: AppConstants.shadow_1,
        borderRadius: 0.radius10,
      ),
      child: child,
    );
  }
}
