import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static void showNormalToast(String title,
      {String subTitle,
      Color backColor = Colors.white,
      Color titleColor = Colors.white,
      Color subTitleColor = Colors.white70}) {
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subTitle,
      crossPage: true,
      onlyOne: false,
      align: Alignment.topCenter,
      hideCloseButton: true,
      enableSlideOff: true,
      backgroundColor: backColor,
      backButtonBehavior: BackButtonBehavior.close,
      subTitleStyle: TextStyle(color: subTitleColor),
      titleStyle: TextStyle(color: titleColor),
    );
  }

  static Future<void> showSimpleDialog(
      {String desc,
      @required String title,
      @required BuildContext context,
      Function() okPress,
      Function() cancelPress,
      DialogType dialogType = DialogType.INFO_REVERSED}) async {
    await AwesomeDialog(
      context: context,
      width: 400,
      useRootNavigator: true,
      dialogType: dialogType,
      desc: desc,
      title: title,
      btnOkColor: Colors.red,
      btnCancelColor: Colors.green,
      btnCancelText: 'Evet',
      btnOkText: 'Hayır',
      headerAnimationLoop: false,
      btnCancelOnPress: okPress,
      btnOkOnPress: cancelPress,
    ).show();
  }

  static void showErrorToast(String title,
      {String subTitle,
      Color backColor = Colors.red,
      Color titleColor = Colors.white,
      Color subTitleColor = Colors.white70}) {
    BotToast.showSimpleNotification(
      crossPage: true,
      onlyOne: false,
      title: title,
      subTitle: subTitle,
      align: Alignment.topCenter,
      closeIcon: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      enableSlideOff: true,
      backgroundColor: backColor,
      backButtonBehavior: BackButtonBehavior.close,
      subTitleStyle: TextStyle(color: subTitleColor),
      titleStyle: TextStyle(color: titleColor),
    );
  }

  static void showSuccesToast(String title,
      {String subTitle,
      Color backColor = Colors.green,
      Color titleColor = Colors.white,
      Color subTitleColor = Colors.white70}) {
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subTitle,
      align: Alignment.topCenter,
      hideCloseButton: false,
      enableSlideOff: true,
      closeIcon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      backgroundColor: backColor,
      backButtonBehavior: BackButtonBehavior.close,
      subTitleStyle: TextStyle(color: subTitleColor),
      titleStyle: TextStyle(color: titleColor),
    );
  }

  static List<BoxShadow> shadow_1 = [
    BoxShadow(
        color: Colors.black.withOpacity(.15),
        offset: Offset(1, 1),
        blurRadius: 2,
        spreadRadius: 0.2)
  ];
  static List<BoxShadow> shadow_2 = [
    BoxShadow(
        color: Colors.black.withOpacity(.5),
        offset: Offset(2, 2),
        blurRadius: 4,
        spreadRadius: 0.4)
  ];

  static String emailKontrol(String mail) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    if (!regex.hasMatch(mail)) {
      return '';
    } else {
      return null;
    }
  }
}
