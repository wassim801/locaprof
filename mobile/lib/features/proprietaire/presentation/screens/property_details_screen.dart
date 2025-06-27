import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locapro/core/providers/providers.dart';
import 'package:locapro/features/proprietaire/data/models/property_sub_models.dart';
import '../../data/models/property_model.dart';
import '../../data/providers/property_provider.dart';

class PropertyDetailsScreen extends ConsumerWidget {
  final PropertyModel property;

  const PropertyDetailsScreen({Key? key, required this.property}) : super(key: key);

  static PropertyModel getMockProperty() {
    return PropertyModel(
      id: '1',
      proprietaireId: 'owner123',
      titre: 'Bel Appartement au Centre-Ville',
      description: 'Magnifique appartement rénové avec vue sur la ville',
      type: 'appartement',
      statut: 'disponible',
      adresse: Address(
        rue: '123 Avenue Mohammed V',
        ville: 'Casablanca',
        codePostal: '20000',
        pays: 'Maroc',
        coordonnees: {'latitude': 33.5731, 'longitude': -7.5898},
      ),
      caracteristiques: Characteristics(
        surface: 85.0,
        pieces: 4,
        chambres: 2,
        sallesDeBain: 1,
        equipements: ['Climatisation', 'Ascenseur', 'Parking', 'Cuisine équipée'],
        description: 'Appartement lumineux et moderne',
      ),
      loyer: Rental(
        prix: 8000.0,
        periodicite: 'mensuel',
        charges: 500.0,
        garantie: 16000.0,
        conditionsBail: ['Contrat minimum 1 an', 'Garant exigé'],
      ),
      photos: [
        Photo(
          url: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
          description: 'Salon',
          isPrincipale: true,
        ),
        Photo(
          url: 'https://images.unsplash.com/photo-1560448204-603b3fc33ddc',
          description: 'Chambre principale',
          isPrincipale: false,
        ),
      ],
      documents: [
        Document(
          nom: 'Contrat de bail',
          url: 'https://example.com/contrat.pdf',
          type: 'PDF',
          dateAjout: DateTime.now(),
          description: 'Contrat de location',
        ),
      ],
      dateDisponibilite: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.titre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/property/edit',
                arguments: property,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (property.photos.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: property.photos.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      property.photos[index].url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.titre,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${property.loyer.prix}€ ${property.loyer.periodicite}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSection(
                    context,
                    'Description',
                    Text(property.description),
                  ),
                  _buildSection(
                    context,
                    'Caractéristiques',
                    _buildCharacteristics(context),
                  ),
                  _buildSection(
                    context,
                    'Adresse',
                    _buildAddress(context),
                  ),
                  _buildSection(
                    context,
                    'Loyer et charges',
                    _buildRental(context),
                  ),
                  if (property.documents.isNotEmpty)
                    _buildSection(
                      context,
                      'Documents',
                      _buildDocuments(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        content,
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildCharacteristics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          'Surface',
          '${property.caracteristiques.surface} m²',
        ),
        _buildInfoRow(
          context,
          'Pièces',
          property.caracteristiques.pieces.toString(),
        ),
        _buildInfoRow(
          context,
          'Chambres',
          property.caracteristiques.chambres.toString(),
        ),
        _buildInfoRow(
          context,
          'Salles de bain',
          property.caracteristiques.sallesDeBain.toString(),
        ),
        if (property.caracteristiques.equipements.isNotEmpty) ...[
          const SizedBox(height: 8.0),
          const Text('Équipements:'),
          Wrap(
            spacing: 8.0,
            children: property.caracteristiques.equipements
                .map((e) => Chip(label: Text(e)))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(property.adresse.rue),
        Text('${property.adresse.codePostal} ${property.adresse.ville}'),
        Text(property.adresse.pays),
      ],
    );
  }

  Widget _buildRental(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          'Loyer',
          '${property.loyer.prix}€ ${property.loyer.periodicite}',
        ),
        _buildInfoRow(
          context,
          'Charges',
          '${property.loyer.charges}€',
        ),
        _buildInfoRow(
          context,
          'Garantie',
          '${property.loyer.garantie}€',
        ),
        if (property.loyer.conditionsBail.isNotEmpty)
          _buildInfoRow(
            context,
            'Conditions du bail',
            property.loyer.conditionsBail.join(', '),
          ),
      ],
    );
  }

  Widget _buildDocuments(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: property.documents.map((doc) {
        return InkWell(
          onTap: () {
            // TODO: Implement document viewing
          },
          child: Chip(
            avatar: const Icon(Icons.description),
            label: Text(doc.type),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la propriété'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette propriété ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await ref.read(propertyProvider.notifier).deleteProperty(property.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Propriété supprimée avec succès')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la suppression: $e')),
          );
        }
      }
    }
  }
}