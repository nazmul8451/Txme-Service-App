import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Widgegt/MessageBubbleWidget/ChatTile.dart';
import '../controller/chat_controller.dart';
import 'chat_details_page.dart';

class ChatHomePage extends StatefulWidget {
  ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  initState(){
    super.initState();
    Get.put(ChatController());
  }
  
  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Text(
                "Chats",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000)
                ),
              ),

              SizedBox(height: 16.h),

              /// Search
              TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF2F2F2),
                  prefixIcon: SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.search,
                        height: 16.h,
                        width: 16.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// Chat List
              Expanded(
                child: Obx(() {
                  final chats = controller.filteredChats;

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.getChats();
                    },
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];

                        return InkWell(
                          onTap: () {
                            Get.to(() => ChatDetailsPage(chat: chat));
                          },
                          child: ChatTile(chat: chat),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2),
    );
  }
}
