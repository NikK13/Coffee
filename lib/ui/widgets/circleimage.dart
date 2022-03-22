import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final Animation<Color>? color;
  final double? size;
  final String? image;
  final bool? isImg;

  const CircleImage({
    Key? key,
    this.color,
    this.isImg,
    this.image,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: isImg!
            ? Image.network(
                image!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadPr) {
                  if (loadPr == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: color,
                      value: loadPr.expectedTotalBytes != null
                          ? loadPr.cumulativeBytesLoaded /
                              loadPr.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, e, s) => Container(
                  width: size,
                  height: size,
                  color: Colors.grey[850],
                  child: Center(
                    child: Icon(
                      Icons.photo_camera,
                      size: size! / 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Container(
                width: size,
                height: size,
                color: Colors.grey[850],
                child: Center(
                  child: Icon(
                    Icons.photo_camera,
                    size: size! / 2,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
