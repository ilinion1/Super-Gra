import 'dart:math';

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
import 'package:super_gra/src/screens/super_ruletka/super_ruletka_screen.dart';

enum SaperItems { friend, enemy }

class FortuneNumberScreen extends StatefulWidget {
  const FortuneNumberScreen({super.key});

  @override
  State<FortuneNumberScreen> createState() => _FortuneNumberScreenState();
}

class _FortuneNumberScreenState extends State<FortuneNumberScreen> {
  List<int> userChoice = [];
  int botChoice = -1;

  bool isGameStarted = false;
  double koeff = 1;

  void updatekoeff() {
    if (userChoice.isEmpty) {
      koeff = 1;
    } else {
      koeff = double.parse((25 / userChoice.length).toStringAsFixed(2));
    }
    setState(() {});
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
            Text('Цифри на удачу', style: AppTextStyles.header16),
          ],
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: AppColors.background),
            onPressed: () {
              final subtitles = [
                '25 номерів на полі — потрібно вибрати від 1 до 10 улюблених.',
                'Після вибору вам потрібно буде зловити Удачу. Випадковим чином буде обрано 1 число.',
                'Коефіцієнт обчислюється від кількості обраних вами осередків: що більше кількості осередків, то менше коефіцієнт'
              ];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(
                    title: 'Цифри на удачу',
                    subtitles: subtitles,
                  ),
                ),
              );
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.info, width: 24.w),
                SizedBox(width: 4.w),
                Text('Умови', style: AppTextStyles.caption12),
              ],
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.h,
              mainAxisExtent: 65.h,
              childAspectRatio: 1,
            ),
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (isGameStarted) return;
                  if (userChoice.contains(index)) {
                    userChoice.remove(index);
                    setState(() {});
                  } else if (userChoice.length < 10) {
                    userChoice.add(index);
                    setState(() {});
                  }
                  updatekoeff();
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.blue),
                    gradient: userChoice.contains(index) && botChoice == index
                        ? AppColors.mainGradient
                        : null,
                    color: userChoice.contains(index) && botChoice == index
                        ? null
                        : userChoice.contains(index)
                            ? AppColors.blue
                            : botChoice == index
                                ? AppColors.pink
                                : AppColors.background,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.header16,
                    ),
                  ),
                ),
              );
            },
          ),
          Gap.height(20.h),
          Text(
            koeff == 1
                ? 'Оберіть від 1 до 25 цифр'
                : 'Коефіціент за одну цифру: $koeff',
            style: AppTextStyles.caption12.copyWith(color: AppColors.grey),
          ),
        ],
      ),
      bottomSheet: SizedBox(
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
                    if (isGameStarted || userChoice.isEmpty) return;
                    Provider.block.changeBlock(true);
                    await context.read<MoneyCubit>().setMoney(-money);
                    isGameStarted = true;
                    botChoice = Random().nextInt(25);
                    setState(() {});
                    await Future.delayed(const Duration(seconds: 2));
                    if (!mounted) return;
                    if (userChoice.contains(botChoice)) {
                      await context
                          .read<MoneyCubit>()
                          .setMoney((money * koeff).toInt());

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.callSnackbar(
                            (money * koeff).toInt(), context),
                      );
                    }
                    botChoice = -1;
                    isGameStarted = false;
                    Provider.block.changeBlock(false);
                    setState(() {});
                  },
                ),
                Gap.height(32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
