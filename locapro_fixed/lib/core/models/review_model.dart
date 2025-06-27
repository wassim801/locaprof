import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String propertyId;
  final String userId;
  final double rating;
  final String comment;
  final List<String>? photos;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, double>? categoryRatings; // e.g., {cleanliness: 5.0, location: 4.5}
  final String? ownerResponse;
  final DateTime? ownerResponseDate;

  ReviewModel({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.photos,
    required this.createdAt,
    this.updatedAt,
    this.categoryRatings,
    this.ownerResponse,
    this.ownerResponseDate,
  });

  ReviewModel copyWith({
    double? rating,
    String? comment,
    List<String>? photos,
    Map<String, double>? categoryRatings,
    String? ownerResponse,
  }) {
    return ReviewModel(
      id: id,
      propertyId: propertyId,
      userId: userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      categoryRatings: categoryRatings ?? this.categoryRatings,
      ownerResponse: ownerResponse ?? this.ownerResponse,
      ownerResponseDate: ownerResponse != null ? DateTime.now() : ownerResponseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'categoryRatings': categoryRatings,
      'ownerResponse': ownerResponse,
      'ownerResponseDate': ownerResponseDate?.toIso8601String(),
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      userId: json['userId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      photos: json['photos'] != null
          ? List<String>.from(json['photos'] as List)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      categoryRatings: json['categoryRatings'] != null
          ? Map<String, double>.from(json['categoryRatings'] as Map)
          : null,
      ownerResponse: json['ownerResponse'] as String?,
      ownerResponseDate: json['ownerResponseDate'] != null
          ? DateTime.parse(json['ownerResponseDate'] as String)
          : null,
    );
  }

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      propertyId: data['propertyId'] as String,
      userId: data['userId'] as String,
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] as String,
      photos: data['photos'] != null
          ? List<String>.from(data['photos'] as List)
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      categoryRatings: data['categoryRatings'] != null
          ? Map<String, double>.from(data['categoryRatings'] as Map)
          : null,
      ownerResponse: data['ownerResponse'] as String?,
      ownerResponseDate: data['ownerResponseDate'] != null
          ? (data['ownerResponseDate'] as Timestamp).toDate()
          : null,
    );
  }

  double get averageCategoryRating {
    if (categoryRatings == null || categoryRatings!.isEmpty) {
      return rating;
    }
    final sum = categoryRatings!.values.reduce((a, b) => a + b);
    return sum / categoryRatings!.length;
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}