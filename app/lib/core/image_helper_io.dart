import 'dart:io';
import 'package:flutter/material.dart';

/// 原生平台 — 用 Image.file
Widget buildLocalImage(
  String path, {
  required double width,
  required double height,
  required Widget fallback,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => fallback,
  );
}
