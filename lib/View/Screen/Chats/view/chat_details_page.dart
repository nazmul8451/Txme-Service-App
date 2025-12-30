import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../Widgegt/MessageBubbleWidget/MessageBubble.dart';
import '../controller/message_controller.dart';
import '../model/chat_model.dart';

class ChatDetailsPage extends StatelessWidget {
  final ChatModel chat;
  ChatDetailsPage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.put(MessageController(chat.id));

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        elevation: 1,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Center(
            child: SizedBox(
              height: 18.h,
              width: 18.w,
              child: SvgPicture.asset(
                AppIcons.backIcons,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chat.avatar),
            ),
            SizedBox(width: 10.w),
            Text(
              chat.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: SvgPicture.asset(
                  AppIcons.dots3,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// MESSAGE LIST
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  reverse: true, // ✅ START FROM BOTTOM
                  padding: EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return MessageBubble(message: msg);
                  },
                );
              }),
            ),

            /// INPUT FIELD

            Container(
              width: 353.w,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(43.r),
                color: Color(0xffF7F7F7),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(43.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF7F7F7),

                        suffixIcon: SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: Center(
                            child: GestureDetector(
                              onTap: controller.sendMessage,
                              child: SvgPicture.asset(
                                AppIcons.rightarrow,
                                height: 24.h,
                                width: 24.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                      ),

                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
