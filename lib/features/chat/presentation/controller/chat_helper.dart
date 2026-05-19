
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:get/get.dart';


class ChatHelper {
  ChatHelper._internal();

  static final ChatHelper _instance = ChatHelper._internal();

  factory ChatHelper() => _instance;

  static ChatHelper get instance => _instance;
  RxList<Rx<ConversationDataModel>> allConversation = RxList();
  RxMap<int, RxList<ChatMessageModel>> allChats = RxMap();

  void addNewConversation(ConversationDataModel element) {
    allConversation.add(element.obs);
  }

  void updateConversation(ChatMessageModel newMessage) {
    var index = allConversation.indexWhere(
      (element) => element.value.id == newMessage.conversationId,
    );
    if (index == -1) return;

    allChats[newMessage.conversationId]?.insert(0, newMessage);
    allConversation[index].value = allConversation[index].value.copyWith(
      lastMessage: newMessage.message,
      updatedAt: newMessage.sendAt,
    );
  }
}
