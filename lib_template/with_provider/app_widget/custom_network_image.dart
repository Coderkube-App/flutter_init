import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;

  const CustomNetworkImage({
    super.key,
    required this.image,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Icon(
        Icons.error,
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
      ),
    );
  }
}
