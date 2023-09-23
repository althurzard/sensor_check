import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Img {
  compassNeedle,
}

extension FilePathImg on Img {
  String get path {
    var value = '';
    switch (this) {
      case Img.compassNeedle:
            value = 'assets/images/compass_needle.png';
            break;
    }
    return value;
  }

  Image get image {
    return Image.asset(path);
  }
}
