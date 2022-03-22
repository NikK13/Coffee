import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'app.dart';

Color getThemedBackgroundColor(BuildContext context){
  return Theme.of(context).brightness == Brightness.light ?
  App.colorLight : const Color(0xFF212121);
}

double getRealPrice(double price, double priceS, priceL, [bool isLarge = false]){
  if(price != 0.0){
    return price;
  }
  else{
    if(!isLarge){
      return priceS;
    }
    else {
      return priceL;
    }
  }
}

Uint8List? imageBytes(String photo){
  if(photo.isNotEmpty){
    final ph = photo.split(',').last;
    return base64.decode(ph);
  }
  return null;
}

Color accent(context) => Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

void scrollToTheTop(ScrollController scrollController){
  scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeIn
  );
}

Widget getIconButton({required Widget child, required BuildContext context, Function()? onTap, Color? color}) => InkWell(
  child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: color ?? (Theme.of(context).brightness == Brightness.light ?
        const Color.fromRGBO(255, 255, 255, 1) : Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), //color of shadow
            spreadRadius: Theme.of(context).brightness == Brightness.light ? 2 : 0, //spread radius
            blurRadius: Theme.of(context).brightness == Brightness.light ? 4 : 2, // blur radius
            offset: Theme.of(context).brightness == Brightness.light ?
              const Offset(2, 3) : const Offset(0, 0)
          )
        ]
      ),
      padding: const EdgeInsets.all(8.0),
      child: child),
  onTap: onTap,
);

Widget get dialogLine => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 2.0, bottom: 4.0),
    height: 4.0,
    width: 24.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey.withOpacity(0.3)
    ),
  ),
);

void showSnackBar(context, text) {
  final isLight = Theme.of(context).brightness == Brightness.light;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 12
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isLight ? Colors.white : Colors.grey[850],
      content: Text(
        text,
        style: TextStyle(color: isLight ? Colors.black : Colors.white),
      ),
    ),
  );
}

int getIndexByPriority(String priority){
  switch(priority){
    case 'low':
      return 0;
    case 'medium':
      return 1;
    case 'high':
      return 2;
    default:
      return 0;
  }
}

Color? getColorByPriority(String priority){
  switch(priority){
    case "low":
      return Colors.greenAccent.shade700;
    case "medium":
      return Colors.amber;
    case "high":
      return Colors.red;
    default:
      return Colors.amber;
  }
}
BoxConstraints getDialogConstraints(BuildContext context){
  return BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.95
  );
}

String getPriorityByIndex(int index){
  switch(index){
    case 0:
      return 'low';
    case 1:
      return 'medium';
    case 2:
      return 'high';
    default:
      return 'low';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}