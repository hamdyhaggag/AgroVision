import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Dimentions on int {
  double get height => _height();

  double get width => _width();

  double get font => _font();

  double _height() {
    return (this).h;
  }

  double _width() {
    return (this).w;
  }

  double _font() {
    return (this).sp;
  }
}
