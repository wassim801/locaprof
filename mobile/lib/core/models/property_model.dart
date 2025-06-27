import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final String proprietaireId;
  final String titre;
  final String description;
  final String type;
  final String statut;
  final double prix;
  final double charges;
  final double caution;
  final String adresse;
  final Map<String, double> coordonnees;
  final List<String> photos;
  final Map<String, dynamic> caracteristiques;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? rating;
  final int? reviewCount;

  PropertyModel({
    required this.id,
    required this.proprietaireId,
    required this.titre,
    required this.description,
    required this.type,
    required this.statut,
    required this.prix,
    required this.charges,
    required this.caution,
    required this.adresse,
    required this.coordonnees,
    required this.photos,
    required this.caracteristiques,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
    this.reviewCount,
  });

  PropertyModel copyWith({
    String? titre,
    String? description,
    String? type,
    String? statut,
    double? prix,
    double? charges,
    double? caution,
    String? adresse,
    Map<String, double>? coordonnees,
    List<String>? photos,
    Map<String, dynamic>? caracteristiques,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
  }) {
    return PropertyModel(
      id: id,
      proprietaireId: proprietaireId,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      type: type ?? this.type,
      statut: statut ?? this.statut,
      prix: prix ?? this.prix,
      charges: charges ?? this.charges,
      caution: caution ?? this.caution,
      adresse: adresse ?? this.adresse,
      coordonnees: coordonnees ?? this.coordonnees,
      photos: photos ?? this.photos,
      caracteristiques: caracteristiques ?? this.caracteristiques,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proprietaireId': proprietaireId,
      'titre': titre,
      'description': description,
      'type': type,
      'statut': statut,
      'prix': prix,
      'charges': charges,
      'caution': caution,
      'adresse': adresse,
      'coordonnees': coordonnees,
      'photos': photos,
      'caracteristiques': caracteristiques,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      proprietaireId: json['proprietaireId'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      statut: json['statut'] as String,
      prix: (json['prix'] as num).toDouble(),
      charges: (json['charges'] as num).toDouble(),
      caution: (json['caution'] as num).toDouble(),
      adresse: json['adresse'] as String,
      coordonnees: Map<String, double>.from(json['coordonnees'] as Map),
      photos: List<String>.from(json['photos'] as List),
      caracteristiques: json['caracteristiques'] as Map<String, dynamic>,
      isAvailable: json['isAvailable'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] as int?,
    );
  }

  factory PropertyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyModel(
      id: doc.id,
      proprietaireId: data['proprietaireId'] as String,
      titre: data['titre'] as String,
      description: data['description'] as String,
      type: data['type'] as String,
      statut: data['statut'] as String,
      prix: (data['prix'] as num).toDouble(),
      charges: (data['charges'] as num).toDouble(),
      caution: (data['caution'] as num).toDouble(),
      adresse: data['adresse'] as String,
      coordonnees: Map<String, double>.from(data['coordonnees'] as Map),
      photos: List<String>.from(data['photos'] as List),
      caracteristiques: data['caracteristiques'] as Map<String, dynamic>,
      isAvailable: data['isAvailable'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      reviewCount: data['reviewCount'] as int?,
    );
  }
}