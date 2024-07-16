import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m_expense/app/models/DTree.dart';

class Utils{
  static ExpiryDateFormatter cardExpiryDateFormatter = ExpiryDateFormatter();
  static CardNumberFormatter cardNumberFormatter = CardNumberFormatter();
  static UppercaseInputFormatter uppercaseInputFormatter = UppercaseInputFormatter();
  static String shortFileName(String fullName){

    String name = fullName.split('.').first;
    String extension = fullName.split('.').last;

    if (fullName.length > 25) {
      // If the file name is longer than 30 characters, modify it
      String firstPart = name.substring(0, 8);
      String lastPart = name.substring(name.length - 8);
      return '$firstPart ... $lastPart.$extension';
    }
    return fullName;
  }
  static List<String> toStrList(RxList<DTree> list){
    return list.map((element) => element.name).toList();
  }
  static List<DTree> toDTList(dynamic data){
    return (data["result"] as List).map((e) => DTree.fromJson(e)).toList();
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  static const defaultDoublePattern = r'\d+\,?\d{0,2}';

  DecimalTextInputFormatter({String? doublePattern})
      : assert(doublePattern == null || double.parse('0.1') == 0.1),
        _doublePattern = doublePattern ?? defaultDoublePattern;

  final String _doublePattern;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(_doublePattern);
    String newText = regEx.stringMatch(newValue.text) ?? '';

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^0-9/]'), '');

    if (filteredValue.length >= 2 &&
        filteredValue[1] == '/' &&
        !oldValue.text.endsWith('/')) {
      // Remove extra "/" if present
      filteredValue = filteredValue.substring(0, 1) + filteredValue.substring(2);
    }

    if (filteredValue.length >= 2 && !filteredValue.contains('/')) {
      // Add "/" after 2 characters
      if (oldValue.text.length != 3) {
        filteredValue = '${filteredValue.substring(0, 2)}/${filteredValue.substring(2)}';
      }
    }

    if (filteredValue.length > 5) {
      filteredValue = filteredValue.substring(0, 5);
    }

    // Ensure first two characters (month) do not exceed 12
    if (filteredValue.length >= 2) {
      int month = int.tryParse(filteredValue.substring(0, 2)) ?? 0;
      if (month > 12) {
        filteredValue = '12' + filteredValue.substring(2);
      }
    }

    // Ensure last two characters (year) do not exceed 31
    // if (filteredValue.length >= 5) {
    //   int year = int.tryParse(filteredValue.substring(3, 5)) ?? 0;
    //   if (year > 31) {
    //     filteredValue = filteredValue.substring(0, 3) + '31';
    //   }
    // }

    return newValue.copyWith(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}
class CardNumberFormatter extends TextInputFormatter {
  static const int maxLength = 25;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String filteredValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Add spaces after every 4 characters
    List<String> chunks = [];
    for (int i = 0; i < filteredValue.length; i += 4) {
      int end = i + 4 < filteredValue.length ? i + 4 : filteredValue.length;
      chunks.add(filteredValue.substring(i, end));
    }
    filteredValue = chunks.join('   ');

    // Handle backspace to delete 3 spaces with the last character
    if (newValue.text.length < oldValue.text.length && filteredValue.endsWith('   ')) {
      int lastSpaceIndex = filteredValue.lastIndexOf(' ');
      filteredValue = filteredValue.substring(0, lastSpaceIndex);
    }

    // Limit to 25 characters
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    return newValue.copyWith(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}

class UppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}





