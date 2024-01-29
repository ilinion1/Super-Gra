import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/widgets/custom_button.dart';
import 'package:super_gra/src/controllers/money_controller.dart';
import 'package:super_gra/src/screens/fortune_number.dart';
import 'package:super_gra/src/screens/settings_screen.dart';
import 'package:super_gra/src/screens/super_ruletka/super_ruletka_screen.dart';
import 'package:super_gra/src/screens/super_saper_screen.dart';
import 'package:super_gra/src/screens/wheel_game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget openScreen(int index) {
    return switch (index) {
      0 => const SuperRuletkaScreen(),
      1 => const SuperSaperScreen(),
      2 => const WheelGameScreen(),
      3 => const FortuneNumberScreen(),
      _ => const SuperRuletkaScreen(),
    };
  }

  String nameScreens(int index) {
    return switch (index) {
      0 => 'Супер Рулетка',
      1 => 'Супер Сапер',
      2 => 'Щасливе колесо',
      3 => 'Цифри на удачу',
      _ => 'Супер Рулетка',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(width: 16.w),
            SvgPicture.asset(AppIcons.logo),
            SizedBox(width: 16.w),
            Text('Супер Гра', style: AppTextStyles.header16)
          ],
        ),
        actions: [
          Row(
            children: [
              SvgPicture.asset(AppIcons.coin),
              SizedBox(width: 4.w),
              BlocBuilder<MoneyCubit, int>(
                builder: (context, state) {
                  return Text('$state', style: AppTextStyles.text14);
                },
              ),
              SizedBox(width: 16.w),
              IconButton(
                style:
                    IconButton.styleFrom(backgroundColor: AppColors.background),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ),
                icon: SvgPicture.asset(AppIcons.settings, width: 24.w),
              ),
              SizedBox(width: 16.w),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: <Widget>[
              ...List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 9.h),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/game_${index + 1}.png',
                        width: double.infinity,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 17.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameScreens(index),
                              style: (index == 1)
                                  ? AppTextStyles.header16.copyWith(
                                      color: Colors.black,
                                    )
                                  : AppTextStyles.header16,
                            ),
                            SizedBox(height: 23.h),
                            SuperCustomButton(
                              text: 'Грати',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => openScreen(index),
                                ),
                              ),
                              isSmall: true,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
