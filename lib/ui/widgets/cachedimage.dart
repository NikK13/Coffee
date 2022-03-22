import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final double? radius;
  final bool withDarkFilter;

  const CachedImage({Key? key,this.url, this.radius, this.withDarkFilter = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url!,
      imageBuilder: (context, imageProvider) => Container(
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          gradient: withDarkFilter ? const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7],
          ) : null,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(radius!),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          color: Colors.grey[850],
        ),
        child: const Center(
          child: Icon(
            Icons.photo_camera,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
            color: Colors.grey[850],
          ),
          child: const Center(
            child: Icon(
              Icons.photo_camera,
              size: 36,
              color: Colors.white,
            ),
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }

  Image? makeSquare(Image src) {
    var height = src.height;
    var width = src.width;
    if (src.width! < src.height!) {
      height = width;
    } else if (src.width! > src.height!) {
      width = height;
    }

    final dst = Image(
      image: src.image,
      width: width,
      height: height,
    );

    /*  var dy = src.height / height;
    var dx = src.width / width;

    final xOffset = ((width - size) ~/ 2);
    final yOffset = ((height - size) ~/ 2);

    final scaleX = Int32List(size);
    for (var x = 0; x < size; ++x) {
      scaleX[x] = ((x + xOffset) * dx).toInt();
    }

    for (var y = 0; y < size; ++y) {
      final y2 = ((y + yOffset) * dy).toInt();
      for (var x = 0; x < size; ++x) {
        dst.setPixel(x, y, src.getPixel(scaleX[x], y2));
      }
    }
 */
    return dst;
  }
}
