  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:locapro/core/providers/providers.dart';
import 'package:locapro/features/proprietaire/data/models/property_sub_models.dart';
  import '../../data/providers/property_provider.dart';
  import '../../data/models/property_model.dart';
  import '../../../../core/widgets/base_state_widget.dart';

  class ProprietaireDashboardScreen extends ConsumerWidget {
    const ProprietaireDashboardScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final mockProperties = [
  PropertyModel(
    id: 'mock-001',
    proprietaireId: 'owner-123',
    titre: 'Appartement spacieux à Tunis',
    description: 'Appartement de 3 pièces situé au centre-ville de Tunis.',
    type: 'appartement',
    statut: 'disponible',
    adresse: Address(
      rue: 'Rue de Marseille',
      ville: 'Tunis',
      codePostal: '1000',
      pays: 'Tunisie',
      coordonnees: {'latitude': 36.8065, 'longitude': 10.1815},
    ),
    caracteristiques: Characteristics(
      surface: 120,
      pieces: 4,
      chambres: 3,
      sallesDeBain: 2,
      equipements: ['Climatisation', 'Chauffage central', 'Balcon'],
      description: 'Appartement moderne et lumineux.',
    ),
    loyer: Rental(
      prix: 900.0,
      periodicite: 'mensuel',
      charges: 50.0,
      garantie: 1800.0,
      conditionsBail: ['Pas d’animaux', 'Non-fumeur'],
    ),
    photos: [
      Photo(
        url: 'https://via.placeholder.com/300x200',
        description: 'Façade de l’immeuble',
        isPrincipale: true,
      ),
    ],
    documents: [
      Document(
        nom: 'Contrat de location',
        url: 'https://example.com/docs/contrat.pdf',
        type: 'pdf',
        dateAjout: DateTime.now().subtract(const Duration(days: 7)),
        description: 'Contrat modèle',
      ),
    ],
    dateDisponibilite: DateTime.now().add(const Duration(days: 10)),
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
  ),

  PropertyModel(
    id: 'mock-002',
    proprietaireId: 'owner-456',
    titre: 'Villa avec jardin à Hammamet',
    description: 'Villa luxueuse avec piscine et grand jardin.',
    type: 'villa',
    statut: 'loué',
    adresse: Address(
      rue: 'Route touristique',
      ville: 'Hammamet',
      codePostal: '8050',
      pays: 'Tunisie',
      coordonnees: {'latitude': 36.4, 'longitude': 10.6167},
    ),
    caracteristiques: Characteristics(
      surface: 350,
      pieces: 6,
      chambres: 5,
      sallesDeBain: 4,
      equipements: ['Piscine', 'Garage', 'Jardin', 'Cuisine équipée'],
      description: 'Villa haut standing pour grande famille.',
    ),
    loyer: Rental(
      prix: 3500.0,
      periodicite: 'mensuel',
      charges: 200.0,
      garantie: 5000.0,
      conditionsBail: ['Pas de fêtes', 'Entretien hebdomadaire requis'],
    ),
    photos: [],
    documents: [],
    dateDisponibilite: DateTime.now().add(const Duration(days: 60)),
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    updatedAt: DateTime.now(),
  ),
];

final propertiesState = AsyncValue.data(mockProperties);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Tableau de bord'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/proprietaire/property/form');
              },
            ),
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () {
                Navigator.pushNamed(context, '/proprietaire/statistics');
              },
            ),
          ],
        ),
        body: BaseStateWidget<List<PropertyModel>>(
          state: propertiesState,
          onData: (properties) {
            if (properties.isEmpty) {
              return const Center(
                child: Text('Aucune propriété trouvée'),
              );
            }

            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/property/details',
                      arguments: property,
                    );
                  },
                );
              },
            );
          },
        ),
      );
    }
  }

  class PropertyCard extends StatelessWidget {
    final PropertyModel property;
    final VoidCallback onTap;

    const PropertyCard({
      Key? key,
      required this.property,
      required this.onTap,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: property.photos.isNotEmpty
              ? Image.network(
                  property.photos.first.url,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.home),
          title: Text(property.titre),
          subtitle: Text(
            '${property.caracteristiques.surface}m² - ${property.adresse.ville}',
          ),
          trailing: Text(
            '${property.loyer.prix}€',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: onTap,
        ),
      );
    }
  }