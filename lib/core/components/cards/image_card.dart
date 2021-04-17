import 'dart:io';

import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final File image;

  const ImageCard({Key key, @required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 0.radius10,
          boxShadow: AppConstants.shadow_2),
      margin: [5, 10].paddingSymmetric,
      child: ClipRRect(
          borderRadius: 0.radius10,
          child: Image.file(
            image,
          )),
    );
  }
}
