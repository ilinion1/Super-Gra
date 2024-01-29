import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RollArea extends StatefulWidget {
  const RollArea({
    super.key,
    required this.controller,
    required this.fruits,
  });

  final ScrollController controller;
  final List<String> fruits;

  @override
  State<RollArea> createState() => _RollAreaState();
}

class _RollAreaState extends State<RollArea> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 110.h,
          child: ListView(
            controller: widget.controller,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemExtent: 88.w,
            children: List.generate(
              110,
              (index) => Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Image.asset(
                  widget.fruits[index],
                  width: 80.w,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/winning_line.png',
            height: 110.h,
          ),
        ),
      ],
    );
  }
}
