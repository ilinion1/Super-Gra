import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/utils/gap.dart';
import 'package:super_gra/src/common/widgets/custom_button.dart';
import 'package:super_gra/src/common/widgets/custom_snackbar.dart';
import 'package:super_gra/src/common/widgets/custom_text_field.dart';
import 'package:super_gra/src/controllers/block_button_controller.dart';
import 'package:super_gra/src/controllers/money_controller.dart';
import 'package:super_gra/src/screens/super_ruletka/previous_widgets.dart';
import 'package:super_gra/src/screens/super_ruletka/roll_area.dart';

const fruitsImages = [
  AppImages.banana,
  AppImages.wildBerries,
  AppImages.berries,
];

class SuperRuletkaScreen extends StatefulWidget {
  const SuperRuletkaScreen({super.key});

  @override
  State<SuperRuletkaScreen> createState() => _SuperRuletkaScreenState();
}

class _SuperRuletkaScreenState extends State<SuperRuletkaScreen> {
  late final ScrollController _scrollController;
  late final List<String> fruits;

  final rand = Random();

  int x = 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 44.w);
    fruits = List.generate(78, (index) => AppImages.banana);
    fruits.addAll(List.generate(24, (index) => AppImages.wildBerries));
    fruits.addAll(List.generate(10, (index) => AppImages.berries));
    fruits.shuffle();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isRightFruit(int index) {
    return x == 2 && fruits[index + 2] == 'assets/images/banana.png' ||
        x == 3 && fruits[index + 2] == 'assets/images/wild_berries.png' ||
        x == 4 && fruits[index + 2] == 'assets/images/berries.png';
  }

  @override
  Widget build(BuildContext context) {
    final rand = Random();
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            Text('Супер Рулетка', style: AppTextStyles.header16),
          ],
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: AppColors.background),
            onPressed: () {
              final subtitles = [
                'Головна задача супер рулетки: вгадати фрукт, який випаде наступним.',
                'Банани випидають найчастіше, тому за них можна отримати лише 2x до ставки.',
                'Виноград випадає рідше, тому за нього можна отримати 3х до ставки.',
                'Найкращій слот — вишня. За нього можна отримати одразу 3х, але майте на увазі, що отримати його найважче!',
              ];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(
                    title: 'Супер рулетка',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PreviousWin(rand: rand),
                  SizedBox(height: 8.h),
                  const PreviousHundred(),
                ],
              ),
            ),
            Gap.height(33.h),
            RollArea(controller: _scrollController, fruits: fruits),
            Gap.height(23.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 162.h,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: x == index + 2
                                ? Border.all(color: Colors.white, width: 2.w)
                                : null,
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.background,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(fruitsImages[index], width: 44.w),
                                Gap.height(8.h),
                                Text('${index + 2}x',
                                    style: AppTextStyles.header16),
                                Text(
                                  'Ви ставили: 100 разів',
                                  style: AppTextStyles.caption12
                                      .copyWith(color: AppColors.grey),
                                ),
                                Center(
                                  child: SuperCustomButton(
                                    text: 'Ставка',
                                    isSmall: true,
                                    onPressed: () => setState(() {
                                      x = index + 2;
                                    }),
                                    buttonStyleEnum: x == index + 2
                                        ? SuperButtonStyleEnum.common
                                        : SuperButtonStyleEnum.cancel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gap.height(18.h),
          ],
        ),
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
                    Provider.block.changeBlock(true);
                    context.read<MoneyCubit>().setMoney(-money);
                    final index = Random().nextInt(20) + 79;
                    dev.log(fruits[index + 2]);
                    _scrollController.jumpTo(44.w);
                    _scrollController.animateTo(
                      88.w * (index) + 44.w,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOutCubic,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    if (isRightFruit(index) && mounted) {
                      context.read<MoneyCubit>().setMoney(x * money);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.callSnackbar(x * money, context),
                      );
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.callSnackbar(0, context),
                      );
                    }
                    Provider.block.changeBlock(false);
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

class HelpScreen extends StatelessWidget {
  const HelpScreen({
    super.key,
    required this.title,
    required this.subtitles,
  });

  final String title;
  final List<String> subtitles;

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
            Text('Умови', style: AppTextStyles.header16),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.header16),
            Gap.height(16.h),
            ...List.generate(
              subtitles.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  subtitles[index],
                  style: AppTextStyles.text14.copyWith(color: AppColors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
