import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/app/app_constants.dart';
import '../../extensions/num_extensions.dart';

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
