import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/socket_service.dart';
import '../model/chat_model.dart';

class ChatController extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  /// 🔍 SEARCH
  RxString searchQuery = "".obs;

  RxBool isLoading = false.obs;

  final SocketApi socketApi = Get.find<SocketApi>();
  late String myUserId;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    myUserId = await SharePrefsHelper.getString("userId");
    await getChats();
    initSocket();
  }


  void initSocket() async {

    await socketApi.init();

    socketApi.onMessage((data) {
      final chatId = data['chatId'];
      final index = chatList.indexWhere((c) => c.id == chatId);
      if (index == -1) return;

      final raw = data['message'] ?? data;

      update();

      final old = chatList[index];

      chatList[index] = old.copyWith(
        lastMessage: raw['text'] ?? '',
        time: "Now",
        unreadCount: old.unreadCount + 1,
      );
      update();
    });

  }

  Future<void> getChats() async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.getChat}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        chatList.value = (decoded['data'] as List)
            .map((e) => ChatModel.fromJson(e, myUserId))
            .toList();
        update();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ THIS IS WHAT YOUR UI NEEDS
  List<ChatModel> get filteredChats {
    if (searchQuery.value.isEmpty) {
      return chatList;
    }

    return chatList
        .where((c) =>
        c.name.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ))
        .toList();
  }
}




