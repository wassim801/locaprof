import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // booking, message, review, system
  final Map<String, dynamic>? data; // Additional data specific to notification type
  final DateTime createdAt;
  final bool isRead;
  final String? actionUrl; // Deep link or navigation route

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    required this.createdAt,
    required this.isRead,
    this.actionUrl,
  });

  NotificationModel copyWith({
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      data: data ?? this.data,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      actionUrl: json['actionUrl'] as String?,
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      type: data['type'] as String,
      data: data['data'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool,
      actionUrl: data['actionUrl'] as String?,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
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

  // Helper method to create booking notification
  static NotificationModel createBookingNotification({
    required String id,
    required String userId,
    required String propertyTitle,
    required String status,
    required String bookingId,
  }) {
    String title;
    String message;

    switch (status.toLowerCase()) {
      case 'confirmed':
        title = 'Booking Confirmed';
        message = 'Your booking for $propertyTitle has been confirmed!';
        break;
      case 'cancelled':
        title = 'Booking Cancelled';
        message = 'Your booking for $propertyTitle has been cancelled.';
        break;
      case 'pending':
        title = 'Booking Received';
        message = 'Your booking request for $propertyTitle is being processed.';
        break;
      default:
        title = 'Booking Update';
        message = 'There is an update for your booking of $propertyTitle.';
    }

    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: 'booking',
      data: {
        'bookingId': bookingId,
        'status': status,
      },
      createdAt: DateTime.now(),
      isRead: false,
      actionUrl: '/bookings/$bookingId',
    );
  }

  // Helper method to create message notification
  static NotificationModel createMessageNotification({
    required String id,
    required String userId,
    required String senderName,
    required String chatId,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: 'New Message',
      message: 'You have a new message from $senderName',
      type: 'message',
      data: {
        'chatId': chatId,
        'senderName': senderName,
      },
      createdAt: DateTime.now(),
      isRead: false,
      actionUrl: '/messages/$chatId',
    );
  }
}