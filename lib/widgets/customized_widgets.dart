import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

cachedNetworkImage(mediaLink) {
  return CachedNetworkImage(
    imageUrl: mediaLink,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(
      Icons.error,
    ),
  );
}
