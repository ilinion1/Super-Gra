import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyles {
  static final caption12 = TextStyle(
    fontFamily: 'Codec Pro',
    letterSpacing: 0,
    fontSize: 12.sp,
    height: 14.h / 12.sp,
  );
  static final header16 = TextStyle(
    fontFamily: 'Codec Pro',
    letterSpacing: 0,
    fontSize: 16.sp,
    fontWeight: FontWeight.w800,
    height: 22.h / 16.sp,
  );
  static final text14 = TextStyle(
    fontFamily: 'Codec Pro',
    letterSpacing: 0,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );
  static final header24 = TextStyle(
    fontFamily: 'Codec Pro',
    letterSpacing: 0,
    fontSize: 24.sp,
    fontWeight: FontWeight.w800,
    height: 22.h / 24.sp,
  );
}
