import 'package:flutter/material.dart';

/// Terminal logos are network URLs in Firebase, but bundled assets in demo mode.
Widget appImage(String src, {BoxFit? fit}) {
  if (src.startsWith('http')) return Image.network(src, fit: fit);
  return Image.asset(src, fit: fit);
}
