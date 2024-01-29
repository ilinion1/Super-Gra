import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_gra/src/common/app_colors.dart';
import 'package:super_gra/src/common/app_images.dart';
import 'package:super_gra/src/common/app_text_styles.dart';
import 'package:super_gra/src/common/utils/gap.dart';
import 'package:super_gra/src/common/widgets/custom_button.dart';
import 'package:super_gra/src/controllers/block_button_controller.dart';
import 'package:super_gra/src/controllers/money_controller.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.onButtonPressed,
    this.text,
  });

  final Function(int) onButtonPressed;
  final String? text;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late final GlobalKey<FormState> _formKey;
  String? errorText;

  final moneys = <int>[1, 5, 10, 25, 50, 100];

  void isValid() {
    if (_controller.text.isEmpty) {
      errorText = null;
      setState(() {});
      return;
    }
    final money = int.parse(_controller.text);
    final userMoney = context.read<MoneyCubit>().state;
    if (money < 10) {
      errorText = 'Неможливо поставити менше 10';
    } else if (money > userMoney) {
      errorText = 'Занадто багато! Перевірте баланс';
    } else {
      errorText = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 65.h,
          child: Form(
            key: _formKey,
            child: TextField(
              controller: _controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.blue,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) => isValid(),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: SvgPicture.asset(AppIcons.coin),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 10.w,
                ),
                filled: true,
                fillColor: AppColors.background,
                suffixIcon: (_controller.text.isEmpty)
                    ? null
                    : IconButton(
                        onPressed: () => setState(() {
                          _controller.clear();
                          errorText = null;
                        }),
                        icon: SvgPicture.asset(AppIcons.delete),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.pink),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.pink),
                ),
                errorText: errorText,
                errorStyle: AppTextStyles.caption12.copyWith(
                  color: AppColors.pink,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
              child: SizedBox(
                width: 50.w,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    final money = int.tryParse(_controller.text);
                    _controller.text =
                        ((money ?? 0) + moneys[index]).toString();
                    isValid();
                  },
                  icon: Text('+${moneys[index]}', style: AppTextStyles.text14),
                ),
              ),
            ),
          ),
        ),
        Gap.height(8.h),
        ValueListenableBuilder(
            valueListenable: Provider.block,
            builder: (context, bool value, _) {
              return SuperCustomButton(
                text: widget.text ?? 'Грати',
                buttonStyleEnum:
                    _controller.text.isEmpty || errorText != null || value
                        ? SuperButtonStyleEnum.cancel
                        : SuperButtonStyleEnum.common,
                onPressed: () {
                  if (_controller.text.isEmpty || errorText != null || value) {
                    return;
                  }
                  if (context.read<MoneyCubit>().state <
                      int.parse(_controller.text)) {
                    setState(() {
                      errorText = 'Занадто багато! Перевірте баланс';
                    });
                    return;
                  }
                  widget.onButtonPressed(int.parse(_controller.text));
                },
              );
            }),
      ],
    );
  }
}
