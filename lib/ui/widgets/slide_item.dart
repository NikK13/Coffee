import 'package:flutter/material.dart';

class SlideItem extends StatelessWidget {
  final int? index;
  final List? slideList;

  const SlideItem({
    Key? key,
    this.index,
    this.slideList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          slideList![index!].sliderImage,
          width: 270,
          height: 270,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          slideList![index!].sliderHeading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              slideList![index!].sliderSubHeading,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
