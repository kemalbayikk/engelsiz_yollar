import 'package:flutter/material.dart';

extension CustomPaddingAll on num {
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingSymmetricVertical =>
      EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingSymmetricHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());
}

extension CustomDuration on num {
  Duration get secondDuration => Duration(seconds: this);
  Duration get millisecondsDuration => Duration(milliseconds: this);
  Duration get microsecondsDuration => Duration(microseconds: this);
  Duration get minutesDuration => Duration(minutes: this);
  Duration get hoursDuration => Duration(hours: this);
}

extension ListExtension on List{
  EdgeInsets get paddingSymmetric => EdgeInsets.symmetric(vertical: this[0].toDouble() ?? 0,horizontal: this[1].toDouble() ?? 0);
}

extension CustomSizedBox on num {
  Widget get hSized => SizedBox(
        height: toDouble(),
      );
  Widget get wSized => SizedBox(
        width: toDouble(),
      );
  Widget get myBox => SizedBox(
        width: toDouble(),
        height: toDouble(),
      );
}

extension CustomBorderRadius on num {
  BorderRadius get radius5 => BorderRadius.circular(5);
  BorderRadius get radius7 => BorderRadius.circular(7);
  BorderRadius get radius10 => BorderRadius.circular(10);
  BorderRadius get radius20 => BorderRadius.circular(20);
  BorderRadius get radius30 => BorderRadius.circular(30);
  BorderRadius get radius40 => BorderRadius.circular(40);
  BorderRadius get radius50 => BorderRadius.circular(40);
  BorderRadius get customRadius => BorderRadius.circular(toDouble());
}
