const Property = require('../models/property.model');
const { validationResult } = require('express-validator');

// @desc    Créer une nouvelle propriété
// @route   POST /api/properties
// @access  Private (Propriétaire, Admin)
exports.createProperty = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    // Ajouter le propriétaire automatiquement
    req.body.proprietaire = req.user.id;

    const property = await Property.create(req.body);

    res.status(201).json({
      success: true,
      data: property
    });
  } catch (error) {
    console.error('Erreur lors de la création de la propriété:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de la propriété'
    });
  }
};

// @desc    Obtenir toutes les propriétés avec filtres
// @route   GET /api/properties
// @access  Public
exports.getProperties = async (req, res) => {
  try {
    let query = Property.find({ isActive: true });

    // Filtres
    const {
      ville,
      type,
      prixMin,
      prixMax,
      pieces,
      meuble,
      disponible
    } = req.query;

    if (ville) {
      query = query.where('adresse.ville').regex(new RegExp(ville, 'i'));
    }

    if (type) {
      query = query.where('type').equals(type);
    }

    if (prixMin) {
      query = query.where('loyer.montant').gte(parseInt(prixMin));
    }

    if (prixMax) {
      query = query.where('loyer.montant').lte(parseInt(prixMax));
    }

    if (pieces) {
      query = query.where('caracteristiques.pieces').equals(parseInt(pieces));
    }

    if (meuble !== undefined) {
      query = query.where('caracteristiques.meuble').equals(meuble === 'true');
    }

    if (disponible === 'true') {
      query = query.where('statut').equals('disponible');
    }

    // Pagination
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 10;
    const startIndex = (page - 1) * limit;

    query = query.skip(startIndex).limit(limit);

    // Population
    query = query.populate({
      path: 'proprietaire',
      select: 'nom prenom email telephone'
    });

    const properties = await query;
    const total = await Property.countDocuments({ isActive: true });

    res.status(200).json({
      success: true,
      count: properties.length,
      total,
      pagination: {
        page,
        limit,
        totalPages: Math.ceil(total / limit)
      },
      data: properties
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des propriétés:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des propriétés'
    });
  }
};

// @desc    Obtenir une propriété par ID
// @route   GET /api/properties/:id
// @access  Public
exports.getProperty = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id)
      .populate({
        path: 'proprietaire',
        select: 'nom prenom email telephone'
      });

    if (!property) {
      return res.status(404).json({
        success: false,
        message: 'Propriété non trouvée'
      });
    }

    res.status(200).json({
      success: true,
      data: property
    });
  } catch (error) {
    console.error('Erreur lors de la récupération de la propriété:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération de la propriété'
    });
  }
};

// @desc    Mettre à jour une propriété
// @route   PUT /api/properties/:id
// @access  Private (Propriétaire, Admin)
exports.updateProperty = async (req, res) => {
  try {
    let property = await Property.findById(req.params.id);

    if (!property) {
      return res.status(404).json({
        success: false,
        message: 'Propriété non trouvée'
      });
    }

    // Vérifier la propriété
    if (property.proprietaire.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à modifier cette propriété'
      });
    }

    property = await Property.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    res.status(200).json({
      success: true,
      data: property
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la propriété:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour de la propriété'
    });
  }
};

// @desc    Supprimer une propriété
// @route   DELETE /api/properties/:id
// @access  Private (Propriétaire, Admin)
exports.deleteProperty = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id);

    if (!property) {
      return res.status(404).json({
        success: false,
        message: 'Propriété non trouvée'
      });
    }

    // Vérifier la propriété
    if (property.proprietaire.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à supprimer cette propriété'
      });
    }

    // Soft delete
    property.isActive = false;
    await property.save();

    res.status(200).json({
      success: true,
      message: 'Propriété supprimée avec succès'
    });
  } catch (error) {
    console.error('Erreur lors de la suppression de la propriété:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la suppression de la propriété'
    });
  }
};