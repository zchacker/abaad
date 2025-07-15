import 'dart:convert';

import 'package:abaad/data/model/response/conversation_model.dart';
class MessageModel {
  int totalSize;
  int limit;
  int offset;
  int  status;
  Conversation conversation;
  List<Message> messages;
  String estate_id;

  MessageModel({this.totalSize, this.limit, this.offset, this.status, this.conversation, this.messages,this.estate_id});

  MessageModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    status = json['status'];
    estate_id = json['estate_id'];
    conversation = json['conversation'] != null ? Conversation.fromJson(json['conversation']) : null;
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['status'] = status;
    data['estate_id']=estate_id;
    data['conversation'] = conversation.toJson();
      data['messages'] = messages.map((v) => v.toJson()).toList();
      return data;
  }
}

class Message {
  int id;
  int conversationId;
  int senderId;
  String message;
  List<String> files;
  int isSeen;
  String createdAt;
  String updatedAt;

  Message(
      {this.id,
        this.conversationId,
        this.senderId,
        this.message,
        this.files,
        this.isSeen,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    message = json['message'];
    files = (json['file'] != 'null' && json['file'] != null) ? jsonDecode(json['file']).cast<String>() : [];
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['file'] = files;
    data['is_seen'] = isSeen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
