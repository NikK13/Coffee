import 'dart:typed_data';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String photo;
  final Function? onTap;
  final double size;
  final double radius;

  const ProfilePhoto({
    Key? key,
    this.photo = "default",
    this.onTap,
    this.size = 30,
    this.radius = 12
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: HexColor.fromHex(App.appColor)
          ),
          borderRadius: BorderRadius.circular(radius)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 2),
          child: (photo != "default" && photo.length > 32) ? Image.memory(
            imageBytes(photo)!,
            height: size,
            width: size,
            fit: BoxFit.cover,
          ) : Image.asset(
            "assets/images/def.png",
            width: size, height: size,
            fit: BoxFit.cover,
          ),
        )
      )
    );
  }
}