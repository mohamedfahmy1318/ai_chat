import 'package:ai_chat_app/core/constants/app_assets.dart';
import 'package:ai_chat_app/features/chat/presentation/widgets/suggest_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AppAssets.logoApp,
                width: 48.sp,
                height: 48.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Welcome to AI Chat!',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              'Send a message to start chatting with Gemini AI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 32.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: const [
                SuggestChip(text: 'Tell me a joke'),
                SuggestChip(text: 'Explain quantum physics'),
                SuggestChip(text: 'Write a poem'),
                SuggestChip(text: 'Help me code'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
