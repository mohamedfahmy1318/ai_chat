import 'package:ai_chat_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last
        : null;

    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Image.asset(
            AppAssets.logoApp,
            color: Theme.of(context).colorScheme.primary,
            width: 20.sp,
            height: 20.sp,
          ),
        ),
        title: Text(
          conversation.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
        ),
        subtitle: Text(
          lastMessage?.text ?? 'No messages',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(conversation.updatedAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              '${conversation.messages.length} messages',
              style: TextStyle(color: Colors.grey[400], fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
