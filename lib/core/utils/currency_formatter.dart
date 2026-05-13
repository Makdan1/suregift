import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CurrencyFormatter {
  static String format(num? amount, {String? currency}) {
    if (amount == null) return '';
    final formatter = NumberFormat.currency(
      symbol: currency != null ? '$currency ' : '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatWithDecimals(num? amount, {String? currency}) {
    if (amount == null) return '';
    final formatter = NumberFormat.currency(
      symbol: currency != null ? '$currency ' : '',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any non-numeric characters before parsing
    final cleanText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    double value = double.parse(cleanText);
    final formatter = NumberFormat.simpleCurrency(locale: 'en_NG', decimalDigits: 0, name: '');
    String newText = formatter.format(value).trim();

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
