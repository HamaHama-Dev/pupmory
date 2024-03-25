import 'dart:ui';

import 'package:flutter/painting.dart';

class FlutterHashtag {
  const FlutterHashtag(
      this.hashtag,
      this.color,
      this.size,
      this.rotated,
      );
  final String hashtag;
  final Color color;
  final int size;
  final bool rotated;
}

class FlutterColors {
  const FlutterColors._();

  static const Color popular = Color(0xFF545454);
  static const Color medium = Color(0xFF797979);
  static const Color less = Color(0xFFCECECE);
}

const List<FlutterHashtag> kFlutterHashtags = const <FlutterHashtag>[
  FlutterHashtag('추억', FlutterColors.popular, 100, false),
  FlutterHashtag('당신의', FlutterColors.medium, 24, false),
  FlutterHashtag('함께한', FlutterColors.less, 12, true),
  FlutterHashtag('강아지와', FlutterColors.less, 14, false),
  FlutterHashtag('행복한', FlutterColors.medium, 16, false),
  FlutterHashtag('마음', FlutterColors.less, 12, true),
  FlutterHashtag('함께', FlutterColors.medium, 20, true),
  FlutterHashtag('거예요', FlutterColors.popular, 36, false),
  FlutterHashtag('있을', FlutterColors.popular, 40, false),
  FlutterHashtag('사랑과', FlutterColors.popular, 32, true),
  FlutterHashtag('동안', FlutterColors.less, 12, false),
  FlutterHashtag('순간들을', FlutterColors.less, 14, false),
  FlutterHashtag('강아지와', FlutterColors.less, 16, false),
  FlutterHashtag('있을', FlutterColors.medium, 20, true),
  FlutterHashtag('영원히', FlutterColors.medium, 22, false),
];