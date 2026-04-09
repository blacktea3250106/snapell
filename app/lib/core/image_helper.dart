import 'package:flutter/material.dart';
import 'image_helper_stub.dart'
    if (dart.library.io) 'image_helper_io.dart'
    if (dart.library.html) 'image_helper_web.dart' as impl;

/// 跨平台本地圖片載入
/// Web 上用 Image.network（blob URL），原生用 Image.file
Widget buildLocalImage(
  String path, {
  required double width,
  required double height,
  required Widget fallback,
}) {
  return impl.buildLocalImage(path, width: width, height: height, fallback: fallback);
}
