import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension StringExtension on String {
   Text toText({Color color, double fontSize}) => Text(
        this,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      );
   
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
