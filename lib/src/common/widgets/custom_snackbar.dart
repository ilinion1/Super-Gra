import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/utils/gap.dart';

abstract class CustomSnackbar {
  static SnackBar callSnackbar(int money, BuildContext context) {
    return SnackBar(
      duration: const Duration(milliseconds: 1500),
      backgroundColor: AppColors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      content: SizedBox(
        height: 56.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                'Увага!',
                style: AppTextStyles.text14.copyWith(color: Colors.white),
              ),
              const Spacer(),
              Text(
                'Ви вивели: $money',
                style: AppTextStyles.text14.copyWith(color: Colors.white),
              ),
              Gap.width(4.w),
              SvgPicture.asset(AppIcons.coin, width: 24.w),
            ],
          ),
        ),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 180.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }
}
