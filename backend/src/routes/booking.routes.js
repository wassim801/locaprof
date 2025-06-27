const express = require('express');
const { check } = require('express-validator');
const router = express.Router();

const {
  createBooking,
  getBookings,
  getBooking,
  updateBooking,
  processPayment
} = require('../controllers/booking.controller');

const { protect, authorize } = require('../middleware/auth.middleware');

// Validation pour la création d'une réservation
const bookingValidation = [
  check('property', 'ID de la propriété invalide').isMongoId(),
  check('dateDebut', 'Date de début invalide').isISO8601(),
  check('dateFin', 'Date de fin invalide').isISO8601(),
  check('duree', 'Durée invalide').isNumeric()
];

// Validation pour la mise à jour d'une réservation
const updateBookingValidation = [
  check('statut', 'Statut invalide').optional().isIn([
    'en_attente',
    'confirme',
    'refuse',
    'annule',
    'termine'
  ])
];

// Routes protégées
router
  .route('/')
  .post(
    protect,
    authorize('locataire'),
    bookingValidation,
    createBooking
  )
  .get(
    protect,
    getBookings
  );

router
  .route('/:id')
  .get(
    protect,
    getBooking
  )
  .put(
    protect,
    authorize('proprietaire', 'admin'),
    updateBookingValidation,
    updateBooking
  );

// Route de paiement
router.post(
  '/:id/payment',
  protect,
  authorize('locataire'),
  processPayment
);

module.exports = router;