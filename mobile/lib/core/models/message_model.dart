import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;
  final String type; // text, image, location
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata; // For additional data like image URLs or location coordinates

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.metadata,
  });

  MessageModel copyWith({
    String? content,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      content: content ?? this.content,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      chatId: data['chatId'] as String,
      senderId: data['senderId'] as String,
      receiverId: data['receiverId'] as String,
      content: data['content'] as String,
      type: data['type'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  bool get isSentByMe => senderId == 'currentUserId'; // Replace with actual current user ID logic

  String get timeString {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class ChatModel {
  final String id;
  final List<String> participants;
  final DateTime lastMessageTime;
  final String? lastMessageContent;
  final int unreadCount;
  final String? propertyId; // Optional: If the chat is related to a property

  ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessageTime,
    this.lastMessageContent,
    required this.unreadCount,
    this.propertyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessageContent': lastMessageContent,
      'unreadCount': unreadCount,
      'propertyId': propertyId,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      participants: List<String>.from(json['participants'] as List),
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      lastMessageContent: json['lastMessageContent'] as String?,
      unreadCount: json['unreadCount'] as int,
      propertyId: json['propertyId'] as String?,
    );
  }

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] as List),
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessageContent: data['lastMessageContent'] as String?,
      unreadCount: data['unreadCount'] as int,
      propertyId: data['propertyId'] as String?,
    );
  }
}