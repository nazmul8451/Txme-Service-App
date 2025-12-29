import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Screen/Chats/model/message_model.dart';


class MessageBubble extends StatelessWidget {
  final MessageModel message;
  const MessageBubble({super.key, required this.message});


  @override
  Widget build(BuildContext context) {



    return Align(
      alignment:
      message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 260.w),
        decoration: BoxDecoration(
          color: message.isMe ? Color(0xff3A7DFF) : Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isMe ? Color(0xffFFFFFF) : Color(0xff1F2937),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
