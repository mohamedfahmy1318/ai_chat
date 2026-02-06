import 'package:ai_chat_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestChip extends StatelessWidget {
  const SuggestChip({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(text, style: TextStyle(fontSize: 12.sp)),
      onPressed: () {
        context.read<ChatCubit>().sendMessage(text);
      },
    );
  }
}
