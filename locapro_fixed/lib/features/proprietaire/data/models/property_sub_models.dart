class Address {
  final String rue;
  final String ville;
  final String codePostal;
  final String pays;
  final Map<String, double>? coordonnees;

  Address({
    required this.rue,
    required this.ville,
    required this.codePostal,
    required this.pays,
    this.coordonnees,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      rue: json['rue'] ?? '',
      ville: json['ville'] ?? '',
      codePostal: json['codePostal'] ?? '',
      pays: json['pays'] ?? '',
      coordonnees: json['coordonnees'] != null
          ? {
              'latitude': json['coordonnees']['latitude'] ?? 0.0,
              'longitude': json['coordonnees']['longitude'] ?? 0.0,
            }
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rue': rue,
      'ville': ville,
      'codePostal': codePostal,
      'pays': pays,
      if (coordonnees != null) 'coordonnees': coordonnees,
    };
  }
}

class Characteristics {
  final double surface;
  final int pieces;
  final int chambres;
  final int sallesDeBain;
  final List<String> equipements;
  final String description;

  Characteristics({
    required this.surface,
    required this.pieces,
    required this.chambres,
    required this.sallesDeBain,
    required this.equipements,
    required this.description,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) {
    return Characteristics(
      surface: (json['surface'] ?? 0.0).toDouble(),
      pieces: json['pieces'] ?? 0,
      chambres: json['chambres'] ?? 0,
      sallesDeBain: json['sallesDeBain'] ?? 0,
      equipements: List<String>.from(json['equipements'] ?? []),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surface': surface,
      'pieces': pieces,
      'chambres': chambres,
      'sallesDeBain': sallesDeBain,
      'equipements': equipements,
      'description': description,
    };
  }
}

class Rental {
  final double prix;
  final String periodicite;
  final double charges;
  final double garantie;
  final List<String> conditionsBail;

  static const List<String> periodiciteOptions = [
    'mensuel',
    'trimestriel',
    'semestriel',
    'annuel'
  ];

  Rental({
    required this.prix,
    required this.periodicite,
    required this.charges,
    required this.garantie,
    required this.conditionsBail,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      prix: (json['prix'] ?? 0.0).toDouble(),
      periodicite: json['periodicite'] ?? 'mensuel',
      charges: (json['charges'] ?? 0.0).toDouble(),
      garantie: (json['garantie'] ?? 0.0).toDouble(),
      conditionsBail: List<String>.from(json['conditionsBail'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prix': prix,
      'periodicite': periodicite,
      'charges': charges,
      'garantie': garantie,
      'conditionsBail': conditionsBail,
    };
  }
}

class Photo {
  final String url;
  final String? description;
  final bool isPrincipale;

  Photo({
    required this.url,
    this.description,
    required this.isPrincipale,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['url'] ?? '',
      description: json['description'],
      isPrincipale: json['isPrincipale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'description': description,
      'isPrincipale': isPrincipale,
    };
  }
}

class Document {
  final String nom;
  final String url;
  final String type;
  final DateTime dateAjout;

  Document({
    required this.nom,
    required this.url,
    required this.type,
    required this.dateAjout, required String description,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      nom: json['nom'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      dateAjout: DateTime.parse(json['dateAjout'] ?? DateTime.now().toIso8601String()), description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'url': url,
      'type': type,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }
}