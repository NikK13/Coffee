import 'package:coffee/data/utils/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/utils/extensions.dart';

class PlatformButton extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Function()? onPressed;
  final Function? onLongPress;
  final double borderRadius;

  const PlatformButton({
    Key? key,
    @required this.text,
    this.fontSize = 18,
    @required this.onPressed,
    this.onLongPress,
    this.borderRadius = 8
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(App.platform == "ios") {
      return CupertinoButton(
        onPressed: onPressed!,
        color: HexColor.fromHex(App.appColor),
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.6,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              text!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                fontFamily: App.font,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed!,
      onLongPress: () => onLongPress != null ?
      onLongPress!() : (){},
      style: ElevatedButton.styleFrom(
        primary: HexColor.fromHex(App.appColor),
        textStyle: const TextStyle(
          fontFamily: App.font,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      )
    );
  }
}
