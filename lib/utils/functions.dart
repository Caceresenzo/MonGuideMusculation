import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage networkImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => new CircularProgressIndicator(),
    errorWidget: (context, url, error) => new Icon(Icons.error),
    fit: BoxFit.fill,
  );
}
