import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/screens/super_ruletka/super_ruletka_screen.dart';

class PreviousHundred extends StatelessWidget {
  const PreviousHundred({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: AppColors.background,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Остання сотня:',
                style: AppTextStyles.text14.copyWith(color: AppColors.grey),
              ),
              SizedBox(width: 16.w),
              ...List.generate(
                3,
                (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Image.asset(
                        fruitsImages[index],
                        width: 24.w,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${index == 0 ? 78 : index == 1 ? 12 : 10}',
                      style: AppTextStyles.text14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviousWin extends StatelessWidget {
  const PreviousWin({
    super.key,
    required this.rand,
  });

  final Random rand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: AppColors.background,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              Text(
                'Попередні виграши:',
                style: AppTextStyles.text14.copyWith(color: AppColors.grey),
              ),
              SizedBox(width: 16.w),
              ...List.generate(
                6,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Image.asset(
                    fruitsImages[rand.nextInt(3)],
                    width: 24.w,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
