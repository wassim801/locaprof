import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
// Remove unused image package import since it doesn't exist
import 'package:intl/intl.dart';
import '../../../../core/providers/providers.dart';
import '../../data/models/property_model.dart';
import '../../data/models/property_sub_models.dart';
import '../../../../core/services/upload_service.dart';

class PropertyFormScreen extends ConsumerStatefulWidget {
  final PropertyModel? property;

  const PropertyFormScreen({Key? key, this.property}) : super(key: key);

  @override
  ConsumerState<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends ConsumerState<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _piecesController = TextEditingController();
  final _chambresController = TextEditingController();
  final _sallesDeBainController = TextEditingController();
  final _prixController = TextEditingController();
  final _chargesController = TextEditingController();
  final _garantieController = TextEditingController();
  final _conditionsBailController = TextEditingController();
  final _adresseController = TextEditingController();
  final _villeController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _paysController = TextEditingController();

  String _selectedType = PropertyModel.typeOptions.first;
  String _selectedStatut = PropertyModel.statutOptions.first;
  DateTime? _dateDisponibilite;
  String _periodicite = 'mensuel';
  List<String> _equipements = [];
  List<File> _selectedPhotos = [];
  List<File> _selectedDocuments = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _initializePropertyData();
    }
  }

  void _initializePropertyData() {
    final property = widget.property!;
    _titleController.text = property.titre;
    _descriptionController.text = property.description;
    _selectedType = property.type;
    _selectedStatut = property.statut;
    _dateDisponibilite = property.dateDisponibilite;

    // Caractéristiques
    _surfaceController.text = property.caracteristiques.surface.toString();
    _piecesController.text = property.caracteristiques.pieces.toString();
    _chambresController.text = property.caracteristiques.chambres.toString();
    _sallesDeBainController.text = property.caracteristiques.sallesDeBain.toString();
    _equipements = List<String>.from(property.caracteristiques.equipements);

    // Loyer
    _prixController.text = property.loyer.prix.toString();
    _periodicite = property.loyer.periodicite;
    _chargesController.text = property.loyer.charges.toString();
    _garantieController.text = property.loyer.garantie.toString();
    _conditionsBailController.text = property.loyer.conditionsBail as String;

    // Adresse
    _adresseController.text = property.adresse.rue;
    _villeController.text = property.adresse.ville;
    _codePostalController.text = property.adresse.codePostal;
    _paysController.text = property.adresse.pays;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _surfaceController.dispose();
    _piecesController.dispose();
    _chambresController.dispose();
    _sallesDeBainController.dispose();
    _prixController.dispose();
    _chargesController.dispose();
    _garantieController.dispose();
    _conditionsBailController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _codePostalController.dispose();
    _paysController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedPhotos.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  Future<void> _pickDocuments(dynamic file_picker, dynamic FileType) async {
    final result = await file_picker.FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedDocuments.addAll(
          result.files.map((file) => File(file.path!)),
        );
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uploadService = ref.read(uploadServiceProvider);

      // Upload photos
      final photoUrls = await uploadService.uploadPropertyImages(_selectedPhotos);
      final photos = photoUrls.asMap().entries.map((entry) {
        return Photo(
          url: entry.value,
          isPrincipale: entry.key == 0,
          description: '',
        );
      }).toList();

      // Upload documents
      final documentUrls = await uploadService.uploadPropertyDocuments(_selectedDocuments);
      final documents = documentUrls.map((url) {
        return Document(
          url: url,
          type: 'document',
          description: '', nom: '', dateAjout: DateTime.now(),
        );
      }).toList();

      final property = PropertyModel(
        id: widget.property?.id ?? '',
        proprietaireId: widget.property?.proprietaireId ?? '',
        titre: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        statut: _selectedStatut,
        adresse: Address(
          rue: _adresseController.text,
          ville: _villeController.text,
          codePostal: _codePostalController.text,
          pays: _paysController.text,
        ),
        caracteristiques: Characteristics(
          surface: double.parse(_surfaceController.text),
          pieces: int.parse(_piecesController.text),
          chambres: int.parse(_chambresController.text),
          sallesDeBain: int.parse(_sallesDeBainController.text),
          equipements: _equipements,
          description: _descriptionController.text,
        ),
        loyer: Rental(
          prix: double.parse(_prixController.text),
          periodicite: _periodicite,
          charges: double.parse(_chargesController.text),
          garantie: double.parse(_garantieController.text),
          conditionsBail: [_conditionsBailController.text],
        ),
        photos: photos,
        documents: documents,
        dateDisponibilite: _dateDisponibilite,
        createdAt: widget.property?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final provider = ref.read(propertyProvider.notifier);
      if (widget.property != null) {
        await provider.updateProperty(widget.property!.id, property);
      } else {
        await provider.addProperty(property);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriété enregistrée avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property != null ? 'Modifier la propriété' : 'Ajouter une propriété'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Titre'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Type de bien'),
                    items: PropertyModel.typeOptions
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedStatut,
                    decoration: const InputDecoration(labelText: 'Statut'),
                    items: PropertyModel.statutOptions
                        .map((statut) => DropdownMenuItem(
                              value: statut,
                              child: Text(statut),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedStatut = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    title: const Text('Date de disponibilité'),
                    subtitle: Text(
                      _dateDisponibilite != null
                          ? DateFormat('dd/MM/yyyy').format(_dateDisponibilite!)
                          : 'Non définie',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dateDisponibilite ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _dateDisponibilite = date);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Caractéristiques',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _surfaceController,
                    decoration: const InputDecoration(labelText: 'Surface (m²)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _piecesController,
                    decoration: const InputDecoration(labelText: 'Nombre de pièces'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _chambresController,
                    decoration: const InputDecoration(labelText: 'Nombre de chambres'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _sallesDeBainController,
                    decoration: const InputDecoration(
                        labelText: 'Nombre de salles de bain'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Loyer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _prixController,
                    decoration: const InputDecoration(labelText: 'Prix'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: _periodicite,
                    decoration: const InputDecoration(labelText: 'Périodicité'),
                    items: const [
                      DropdownMenuItem(value: 'mensuel', child: Text('Mensuel')),
                      DropdownMenuItem(value: 'annuel', child: Text('Annuel')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _periodicite = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _chargesController,
                    decoration: const InputDecoration(labelText: 'Charges'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _garantieController,
                    decoration: const InputDecoration(labelText: 'Garantie'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _conditionsBailController,
                    decoration: const InputDecoration(labelText: 'Conditions du bail'),
                    maxLines: 3,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Adresse',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(labelText: 'Rue'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _villeController,
                    decoration: const InputDecoration(labelText: 'Ville'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _codePostalController,
                    decoration: const InputDecoration(labelText: 'Code postal'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _paysController,
                    decoration: const InputDecoration(labelText: 'Pays'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Photos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ..._selectedPhotos.map(
                        (photo) => Stack(
                          children: [
                            Image.file(
                              photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedPhotos.remove(photo);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Icon(Icons.add_photo_alternate),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Documents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ..._selectedDocuments.map(
                        (doc) => Chip(
                          label: Text(doc.path.split('/').last),
                          onDeleted: () {
                            setState(() {
                              _selectedDocuments.remove(doc);
                            });
                          },
                        ),
                      ),
                      ActionChip(
                        label: const Text('Ajouter un document'),
                        onPressed: () => _pickDocuments(null, null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      widget.property != null ? 'Mettre à jour' : 'Ajouter',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}