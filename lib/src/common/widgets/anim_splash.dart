import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:super_gra/src/common/app_colors.dart';

class SuperProgressBar extends StatefulWidget {
  const SuperProgressBar({super.key, required this.child});

  final Widget child;

  @override
  State<SuperProgressBar> createState() => _SuperProgressBarState();
}

class _SuperProgressBarState extends State<SuperProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener(splashListener);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  void splashListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.child,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(splashListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(60.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return GradientCircularProgressIndicator(
                      progress: _controller.value,
                      backgroundColor: Colors.white54,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.blue,
                          Colors.yellowAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Center(
                        child: Text('${(_controller.value * 100).toInt()}%'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
