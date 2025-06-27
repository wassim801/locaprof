import 'property_sub_models.dart';

class PropertyModel {
  final String id;
  final String proprietaireId;
  final String titre;
  final String description;
  final String type;
  final String statut;
  final Address adresse;
  final Characteristics caracteristiques;
  final Rental loyer;
  final List<Photo> photos;
  final List<Document> documents;
  final DateTime? dateDisponibilite;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const List<String> typeOptions = [
    'appartement',
    'maison',
    'studio',
    'villa',
    'bureau',
    'commerce'
  ];

  static const List<String> statutOptions = [
    'disponible',
    'loué',
    'maintenance',
    'inactif'
  ];

  PropertyModel({
    required this.id,
    required this.proprietaireId,
    required this.titre,
    required this.description,
    required this.type,
    required this.statut,
    required this.adresse,
    required this.caracteristiques,
    required this.loyer,
    required this.photos,
    required this.documents,
    this.dateDisponibilite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['_id'] ?? '',
      proprietaireId: json['proprietaire'] ?? '',
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'appartement',
      statut: json['statut'] ?? 'disponible',
      adresse: Address.fromJson(json['adresse'] ?? {}),
      caracteristiques: Characteristics.fromJson(json['caracteristiques'] ?? {}),
      loyer: Rental.fromJson(json['loyer'] ?? {}),
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((photo) => Photo.fromJson(photo))
          .toList(),
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((doc) => Document.fromJson(doc))
          .toList(),
      dateDisponibilite: json['disponibilite']?['dateDisponibilite'] != null
          ? DateTime.parse(json['disponibilite']['dateDisponibilite'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proprietaire': proprietaireId,
      'titre': titre,
      'description': description,
      'type': type,
      'statut': statut,
      'adresse': adresse.toJson(),
      'caracteristiques': caracteristiques.toJson(),
      'loyer': loyer.toJson(),
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'disponibilite': {
        'dateDisponibilite': dateDisponibilite?.toIso8601String(),
      },
    };
  }

  PropertyModel copyWith({
    String? id,
    String? proprietaireId,
    String? titre,
    String? description,
    String? type,
    String? statut,
    Address? adresse,
    Characteristics? caracteristiques,
    Rental? loyer,
    List<Photo>? photos,
    List<Document>? documents,
    DateTime? dateDisponibilite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      proprietaireId: proprietaireId ?? this.proprietaireId,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      type: type ?? this.type,
      statut: statut ?? this.statut,
      adresse: adresse ?? this.adresse,
      caracteristiques: caracteristiques ?? this.caracteristiques,
      loyer: loyer ?? this.loyer,
      photos: photos ?? this.photos,
      documents: documents ?? this.documents,
      dateDisponibilite: dateDisponibilite ?? this.dateDisponibilite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}