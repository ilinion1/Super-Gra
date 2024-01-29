import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/utils/gap.dart';
import 'package:super_gra/src/common/widgets/custom_snackbar.dart';
import 'package:super_gra/src/common/widgets/custom_text_field.dart';
import 'package:super_gra/src/controllers/block_button_controller.dart';
import 'package:super_gra/src/controllers/money_controller.dart';

class WheelGameScreen extends StatefulWidget {
  const WheelGameScreen({super.key});

  @override
  State<WheelGameScreen> createState() => _WheelGameScreenState();
}

class _WheelGameScreenState extends State<WheelGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? dateTime;

  final List<dynamic> items = [
    1,
    2,
    3,
    1.5,
    1,
    0,
    2,
    1.5,
    3,
    1,
    2,
    1.5,
    1,
    3,
    0,
    1.5,
    1,
    2,
    3,
    1.5,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(animate);
  }

  @override
  void dispose() async {
    _controller.removeListener(animate);
    _controller.dispose();
    super.dispose();
  }

  void animate() {
    if (!mounted) return;
    setState(() {});
  }

  void _spinWheel(int money) async {
    _controller.repeat();
    final random = Random();
    final nextInt = random.nextInt(1000) + 2000;
    final duration = Duration(milliseconds: nextInt);
    await Future.delayed(duration);
    if (!mounted) return;
    _controller.stop();
    final value = 1 - _controller.value;
    for (int i = 0; i < items.length; i++) {
      if (i / items.length <= value && value <= (i + 1) / items.length) {
        print(items[i]);
        final amount = (items[i] * money).toInt();
        await context.read<MoneyCubit>().setMoney(amount);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.callSnackbar(amount, context),
        );
      }
    }
    Provider.block.changeBlock(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            IconButton(
              style:
                  IconButton.styleFrom(backgroundColor: AppColors.background),
              onPressed: () => Navigator.pop(context),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppIcons.back, width: 24.w),
                  SizedBox(width: 4.w),
                  Text('Назад', style: AppTextStyles.caption12),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text('Щасливе колесо', style: AppTextStyles.header16),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Container(
                    width: double.infinity,
                    height: 400.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/wheel.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                      child: Container(
                        width: 167.w,
                        height: 167.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.background,
                        ),
                        child: Center(
                          child: Text('Грай!', style: AppTextStyles.header24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Image.asset(
                        'assets/images/triangle_wheel.png',
                        width: 182.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: const CustomBottomSheet(),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          color: AppColors.black,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap.height(22.h),
              Row(
                children: [
                  Text(
                    'Ваша ставка',
                    style: AppTextStyles.caption12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Гаманець',
                    style: AppTextStyles.caption12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  Gap.width(4.w),
                  SvgPicture.asset(AppIcons.coin, width: 24.w),
                  Gap.width(4.w),
                  BlocBuilder<MoneyCubit, int>(
                    builder: (context, state) {
                      return Text('$state', style: AppTextStyles.text14);
                    },
                  ),
                ],
              ),
              Gap.height(16.h),
              CustomTextField(
                onButtonPressed: (money) async {
                  Provider.block.changeBlock(true);
                  context.read<MoneyCubit>().setMoney(-money);
                  context
                      .findAncestorStateOfType<_WheelGameScreenState>()!
                      ._spinWheel(money);
                },
              ),
              Gap.height(32.h),
            ],
          ),
        ),
      ),
    );
  }
}
