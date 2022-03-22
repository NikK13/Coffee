import 'package:flutter/material.dart';
import '../../data/utils/app.dart';
import '../../data/utils/appnavigator.dart';

class PlatformAppBar extends StatelessWidget {
  final String? title;
  final double titleFontSize;

  const PlatformAppBar({
    Key? key,
    this.title,
    this.titleFontSize = 16
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        GestureDetector(
          onTap: (){
            AppNavigator.of(context).pop();
          },
          child: Icon(
            App.platform == "ios" ?
            Icons.arrow_back_ios : Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.light
              ? Colors.black : Colors.white
          )
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            title!,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ],
    );
  }
}
