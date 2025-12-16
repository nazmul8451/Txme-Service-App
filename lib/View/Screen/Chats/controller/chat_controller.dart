import 'package:get/get.dart';
import '../model/chat_model.dart';

class ChatController extends GetxController {
  /// Chat list (Reactive)
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  /// Search
  RxString searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialChats();
    // connectSocket(); // later
  }

  /// Dummy data (replace with API)
  void loadInitialChats() {
    chatList.value = [
      ChatModel(
        id: "1",
        name: "Help & support",
        lastMessage: "Hello are you home?",
        avatar: "https://i.pravatar.cc/150?img=11",
        time: "5mins",
        unreadCount: 2,
      ),
      ChatModel(
        id: "2",
        name: "Leslie",
        lastMessage: "Yes, i will be available tomorrow...",
        avatar: "https://i.pravatar.cc/150?img=12",
        time: "3:00PM",
        unreadCount: 3,
      ),
      ChatModel(
        id: "3",
        name: "Dianne",
        lastMessage: "Nice performance today dear!",
        avatar: "https://i.pravatar.cc/150?img=13",
        time: "1:35PM",
        unreadCount: 0,
      ),
    ];
  }

  /// 🔌 Socket message receive example
  void onNewMessage(Map<String, dynamic> data) {
    final newChat = ChatModel.fromJson(data);
    chatList.insert(0, newChat);
  }

  /// 🔍 Search filter
  List<ChatModel> get filteredChats {
    if (searchQuery.value.isEmpty) return chatList;
    return chatList
        .where((c) =>
        c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
