const express = require('express');
const { check } = require('express-validator');
const router = express.Router();

const {
  createProperty,
  getProperties,
  getProperty,
  updateProperty,
  deleteProperty
} = require('../controllers/property.controller');

const { protect, authorize } = require('../middleware/auth.middleware');

// Validation pour la création/mise à jour d'une propriété
const propertyValidation = [
  check('titre', 'Le titre est requis').notEmpty(),
  check('description', 'La description est requise').notEmpty(),
  check('type', 'Le type de propriété est requis').isIn([
    'appartement',
    'maison',
    'studio',
    'villa',
    'bureau',
    'commerce'
  ]),
  check('adresse.rue', 'L\'adresse est requise').notEmpty(),
  check('adresse.ville', 'La ville est requise').notEmpty(),
  check('adresse.codePostal', 'Le code postal est requis').notEmpty(),
  check('adresse.pays', 'Le pays est requis').notEmpty(),
  check('caracteristiques.surface', 'La surface est requise').isNumeric(),
  check('caracteristiques.pieces', 'Le nombre de pièces est requis').isNumeric(),
  check('loyer.montant', 'Le montant du loyer est requis').isNumeric()
];

// Routes publiques
router.get('/', getProperties);
router.get('/:id', getProperty);

// Routes protégées
router
  .route('/')
  .post(
    protect,
    authorize('proprietaire', 'admin'),
    propertyValidation,
    createProperty
  );

router
  .route('/:id')
  .put(
    protect,
    authorize('proprietaire', 'admin'),
    propertyValidation,
    updateProperty
  )
  .delete(
    protect,
    authorize('proprietaire', 'admin'),
    deleteProperty
  );

module.exports = router;