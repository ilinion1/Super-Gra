import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/widgets/anim_splash.dart';
import 'package:super_gra/src/controllers/money_controller.dart';
import 'package:super_gra/src/controllers/notification_controller.dart';
import 'package:super_gra/src/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  Future<void> requestTrackingPermission() async {
    var status = await AppTrackingTransparency.requestTrackingAuthorization();

    if (status == TrackingStatus.notDetermined) {
      status = await AppTrackingTransparency.requestTrackingAuthorization();
    }

    if (status == TrackingStatus.authorized) {
      log('Permission granted');
    } else {
      log('Permission denied');
    }
  }

  await requestTrackingPermission();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(MyApp(pref: pref)),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.pref});

  final SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MoneyCubit(pref),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(pref),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Super Gra',
          theme: ThemeData.dark(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: AppColors.secondaryBackground,
          ),
          home: const SuperProgressBar(
            child: MainScreen(),
          ),
        ),
      ),
    );
  }
}
