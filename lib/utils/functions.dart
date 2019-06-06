import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

CachedNetworkImage networkImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => Center(
          child: new CircularProgressIndicator(),
        ),
    errorWidget: (context, url, error) => new Icon(
          Icons.error,
          color: Constants.colorAccent,
        ),
    fit: BoxFit.fitWidth,
  );
}
