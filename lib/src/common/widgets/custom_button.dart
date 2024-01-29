import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_text_styles.dart';

enum SuperButtonStyleEnum { common, cancel }

class SuperCustomButton extends StatelessWidget {
  const SuperCustomButton({
    super.key,
    required this.text,
    this.buttonStyleEnum = SuperButtonStyleEnum.common,
    this.onPressed,
    this.isSmall = false,
  });

  final String text;
  final SuperButtonStyleEnum buttonStyleEnum;
  final VoidCallback? onPressed;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: buttonStyleEnum == SuperButtonStyleEnum.common
            ? AppColors.mainGradient
            : null,
        color: buttonStyleEnum == SuperButtonStyleEnum.cancel
            ? AppColors.grey
            : null,
      ),
      child: SizedBox(
        width: isSmall ? 99.w : double.infinity,
        height: isSmall ? 28.h : 54.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: AppTextStyles.text14.copyWith(
              color: buttonStyleEnum == SuperButtonStyleEnum.cancel
                  ? Colors.black54
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
