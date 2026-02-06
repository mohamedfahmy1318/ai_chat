import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final bool isLoading;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Image.asset(
              icon,
              color: color ?? Theme.of(context).colorScheme.primary,
              width: size ?? 24.sp,
              height: size ?? 24.sp,
            ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(text),
    );
  }
}
