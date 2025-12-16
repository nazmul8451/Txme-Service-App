import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Screen/Chats/model/chat_model.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundImage: NetworkImage(chat.avatar),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1F2937)
                  ),
                ),
                SizedBox(height: 13.h),
                Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,

                    color: Color(0xffA5A5A5),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: TextStyle(fontSize: 13.sp, color: Color(0xffA5A5A5),
                fontWeight: FontWeight.w400),
              ),
              if (chat.unreadCount > 0) ...[
                SizedBox(height: 9.h),
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Color(0xff4C545F),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat.unreadCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
