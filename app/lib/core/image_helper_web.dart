import 'package:flutter/material.dart';

/// Web 平台 — localPhotoPath 是 blob URL，用 Image.network
Widget buildLocalImage(
  String path, {
  required double width,
  required double height,
  required Widget fallback,
}) {
  return Image.network(
    path,
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => fallback,
  );
}
