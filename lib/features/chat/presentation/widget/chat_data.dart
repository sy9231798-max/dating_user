

import 'chat_details.dart';
import 'user_details.dart';

class ChatData {
  final ChatDetails chatDetails;
  final UserDetails userDetails;

  ChatData({required this.chatDetails, required this.userDetails});

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatDetails:
      json['Chat_details'] != null
          ? ChatDetails.fromJson(json['Chat_details'])
          : ChatDetails.empty(),
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : UserDetails.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Chat_details'] = chatDetails.toJson();
    data['user_details'] = userDetails.toJson();
    return data;
  }
}