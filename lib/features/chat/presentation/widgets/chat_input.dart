import 'package:ai_chat_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInput({super.key, required this.onSend, this.isLoading = false});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),

      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text field
            Expanded(
              child: CustomTextField(
                controller: _controller,
                hintText: 'Write your message',
                enabled: !widget.isLoading,
                onSubmit: _handleSend,
              ),
            ),

            SizedBox(width: 8.w),

            // Send button
            CustomIconButton(
              icon: AppAssets.sendIcon,
              onPressed: _handleSend,
              isLoading: widget.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
