import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/utils/gap.dart';
import 'package:super_gra/src/common/widgets/custom_button.dart';
import 'package:super_gra/src/common/widgets/custom_snackbar.dart';
import 'package:super_gra/src/common/widgets/custom_text_field.dart';
import 'package:super_gra/src/controllers/money_controller.dart';
import 'package:super_gra/src/screens/super_ruletka/super_ruletka_screen.dart';

enum SaperItems { friend, enemy }

class SuperSaperScreen extends StatefulWidget {
  const SuperSaperScreen({super.key});

  @override
  State<SuperSaperScreen> createState() => _SuperSaperScreenState();
}

class _SuperSaperScreenState extends State<SuperSaperScreen> {
  late final List<SaperItems?> items;
  List<bool> opened = List.generate(25, (index) => false);

  int money = 0;
  int friends = 0;
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
    items = List.generate(3, (index) => SaperItems.enemy);
    items.addAll(List.generate(12, (index) => SaperItems.friend));
    items.addAll(List.generate(10, (index) => null));
    items.shuffle();
  }

  void restartGame() {
    money = 0;
    friends = 0;
    isGameStarted = false;
    opened = List.filled(25, false);
    items.shuffle();
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
            Text('Супер Сапер', style: AppTextStyles.header16),
          ],
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: AppColors.background),
            onPressed: () {
              final subtitles = [
                'На ігровому полі можна зустріти наших та ворогів, а можна нікого не зустріти.',
                'Ворогів завжди менше (звісно) — їх 3.',
                'Вам потрібно знайти всіх наших (їх 12) до того, як ви зіткнетесь із ворогом.',
                'Наші, колм ви їх знаходите, дають вам по x0.2 до вашої ставки. Отже, якщо ви знайдете всіх наших, ви отримаєте х2.4 до ставки.',
                'Але! Ви можете вивести вашу ставку на півдороги — в будь-який момент. ',
                'Якщо ви натрапите на ворога, ваша ставка буде програна.',
                'За перемогу!',
              ];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(
                    title: 'Супер сапер',
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
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              if (opened[index]) {
                final item = items[index];
                return Image.asset(
                  'assets/images/${item == null ? 'empty' : item.name}.png',
                  fit: BoxFit.contain,
                );
              } else {
                return GestureDetector(
                  onTap: () async {
                    if (!isGameStarted) return;
                    opened[index] = true;
                    setState(() {});
                    if (items[index] == SaperItems.enemy) {
                      log('Game over');
                      restartGame();
                      showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (context) => const WinOrLoseDialog(won: false),
                      );
                    } else if (items[index] == SaperItems.friend) {
                      log('x0.2');
                      friends++;
                      setState(() {});
                      if (friends == 12) {
                        final totalMoney =
                            (money + friends * 0.2 * money).toInt();
                        await context.read<MoneyCubit>().setMoney(totalMoney);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbar.callSnackbar(totalMoney, context),
                        );
                        restartGame();
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (context) =>
                              const WinOrLoseDialog(won: true),
                        );
                      }
                    }
                  },
                  child: Image.asset(
                    'assets/images/closed.png',
                    fit: BoxFit.contain,
                  ),
                );
              }
            },
          ),
          Gap.height(14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/friend.png', width: 65.w),
              Text('${12 - friends}', style: AppTextStyles.header16),
              Text(
                '< Зараз на полі >',
                style: AppTextStyles.caption12.copyWith(color: AppColors.grey),
              ),
              Text('3', style: AppTextStyles.header16),
              Image.asset('assets/images/enemy.png', width: 65.w),
            ],
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
                    if (isGameStarted) {
                      final totalMoney =
                          (this.money + friends * 0.2 * this.money).toInt();
                      await context.read<MoneyCubit>().setMoney(totalMoney);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.callSnackbar(totalMoney, context),
                      );
                      restartGame();
                    } else {
                      await context.read<MoneyCubit>().setMoney(-money);
                      isGameStarted = true;
                      this.money = money;
                      setState(() {});
                    }
                  },
                  text: isGameStarted
                      ? 'Вивести: ${(money + friends * 0.2 * money).toInt()}'
                      : null,
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

class WinOrLoseDialog extends StatelessWidget {
  const WinOrLoseDialog({
    super.key,
    required this.won,
  });

  final bool won;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/${won ? 'ua' : 'bullet'}.png', width: 112.w),
        Gap.height(18.h),
        Text(won ? 'Перемога наша!' : 'Ви підірвалися',
            style: AppTextStyles.header24),
        if (won) Gap.height(18.h),
        if (won)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+',
                style: AppTextStyles.caption12.copyWith(color: AppColors.grey),
              ),
              SvgPicture.asset(AppIcons.coin, width: 24.w),
              Gap.width(6.w),
              Text('200', style: AppTextStyles.text14),
            ],
          ),
        Gap.height(18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SuperCustomButton(
            text: 'Грати далі',
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
