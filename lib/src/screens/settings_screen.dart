import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_gra/settings_const.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/screens/ad_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String getTitles(int index) {
    return switch (index) {
      0 => 'Політика конфедунційності',
      1 => 'Умови користування',
      2 => 'Отримати монети за рекламу',
      _ => 'Налаштування повідомлень',
    };
  }

  VoidCallback getOnPressed(int index, BuildContext context) {
    return switch (index) {
      0 => () async {
          final url = Uri.parse(privacyPolicy);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      1 => () async {
          final url = Uri.parse(termsOfUse);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      2 => () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdScreen(
                videoAsset: switch (Random().nextInt(3)) {
                  1 => 'assets/videos/GameAd1.mp4',
                  2 => 'assets/videos/GameAd2.mp4',
                  _ => 'assets/videos/GameAd3.mp4',
                },
              ),
            ),
          );
        },
      _ => () {},
    };
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
            Text('Налаштування', style: AppTextStyles.header16),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: List.generate(
            3,
            (index) => Column(
              children: [
                GestureDetector(
                  onTap: getOnPressed(index, context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Text(
                          getTitles(index),
                          style: AppTextStyles.text14,
                        ),
                        const Spacer(),
                        // if (index == 0)
                        //   BlocBuilder<NotificationCubit, bool>(
                        //     builder: (context, state) {
                        //       return Switch(
                        //         activeColor: AppColors.blue,
                        //         value: state,
                        //         onChanged: (value) async {
                        //           final FlutterLocalNotificationsPlugin
                        //               flutterLocalNotificationsPlugin =
                        //               FlutterLocalNotificationsPlugin();
                        //           await flutterLocalNotificationsPlugin
                        //               .resolvePlatformSpecificImplementation<
                        //                   IOSFlutterLocalNotificationsPlugin>()
                        //               ?.requestPermissions(
                        //                 alert: true,
                        //                 badge: true,
                        //                 sound: true,
                        //               );
                        //           if (!context.mounted) return;
                        //           await context
                        //               .read<NotificationCubit>()
                        //               .setNotification(value);
                        //         },
                        //       );
                        //     },
                        //   ),
                        // if (index != 0)
                        Transform.flip(
                          flipX: true,
                          child: SvgPicture.asset(AppIcons.back),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
