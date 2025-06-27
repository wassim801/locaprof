const Booking = require('../models/booking.model');
const Property = require('../models/property.model');
const { validationResult } = require('express-validator');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// @desc    Créer une nouvelle réservation
// @route   POST /api/bookings
// @access  Private (Locataire)
exports.createBooking = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const property = await Property.findById(req.body.property);
    if (!property) {
      return res.status(404).json({
        success: false,
        message: 'Propriété non trouvée'
      });
    }

    // Vérifier la disponibilité
    if (property.statut !== 'disponible') {
      return res.status(400).json({
        success: false,
        message: 'Cette propriété n\'est pas disponible'
      });
    }

    // Créer la réservation
    const booking = await Booking.create({
      ...req.body,
      locataire: req.user.id,
      proprietaire: property.proprietaire,
      loyer: {
        montantBase: property.loyer.montant,
        charges: property.loyer.charges,
        garantie: property.loyer.garantie,
        total: property.loyer.montant + property.loyer.charges
      }
    });

    // Mettre à jour le statut de la propriété
    property.statut = 'loué';
    await property.save();

    res.status(201).json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Erreur lors de la création de la réservation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de la réservation'
    });
  }
};

// @desc    Obtenir toutes les réservations
// @route   GET /api/bookings
// @access  Private
exports.getBookings = async (req, res) => {
  try {
    let query;

    // Filtrer selon le rôle
    if (req.user.role === 'locataire') {
      query = Booking.find({ locataire: req.user.id });
    } else if (req.user.role === 'proprietaire') {
      query = Booking.find({ proprietaire: req.user.id });
    } else {
      query = Booking.find();
    }

    // Pagination
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 10;
    const startIndex = (page - 1) * limit;

    query = query
      .skip(startIndex)
      .limit(limit)
      .populate('property')
      .populate('locataire', 'nom prenom email telephone')
      .populate('proprietaire', 'nom prenom email telephone');

    const bookings = await query;
    const total = await Booking.countDocuments(query.getQuery());

    res.status(200).json({
      success: true,
      count: bookings.length,
      total,
      pagination: {
        page,
        limit,
        totalPages: Math.ceil(total / limit)
      },
      data: bookings
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des réservations:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des réservations'
    });
  }
};

// @desc    Obtenir une réservation par ID
// @route   GET /api/bookings/:id
// @access  Private
exports.getBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id)
      .populate('property')
      .populate('locataire', 'nom prenom email telephone')
      .populate('proprietaire', 'nom prenom email telephone');

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }

    // Vérifier l'accès
    if (
      req.user.role !== 'admin' &&
      booking.locataire._id.toString() !== req.user.id &&
      booking.proprietaire._id.toString() !== req.user.id
    ) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à accéder à cette réservation'
      });
    }

    res.status(200).json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Erreur lors de la récupération de la réservation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération de la réservation'
    });
  }
};

// @desc    Mettre à jour une réservation
// @route   PUT /api/bookings/:id
// @access  Private
exports.updateBooking = async (req, res) => {
  try {
    let booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }

    // Vérifier l'accès
    if (
      req.user.role !== 'admin' &&
      booking.proprietaire.toString() !== req.user.id
    ) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à modifier cette réservation'
      });
    }

    booking = await Booking.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    res.status(200).json({
      success: true,
      data: booking
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la réservation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour de la réservation'
    });
  }
};

// @desc    Effectuer un paiement
// @route   POST /api/bookings/:id/payment
// @access  Private (Locataire)
exports.processPayment = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }

    if (booking.locataire.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à effectuer ce paiement'
      });
    }

    // Créer la session de paiement Stripe
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: req.user.email,
      line_items: [
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: `Loyer - ${booking.property.titre}`,
              description: `Période: ${new Date(booking.dateDebut).toLocaleDateString()} - ${new Date(booking.dateFin).toLocaleDateString()}`
            },
            unit_amount: booking.loyer.total * 100 // Stripe utilise les centimes
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      success_url: `${req.protocol}://${req.get('host')}/bookings/${booking._id}/success`,
      cancel_url: `${req.protocol}://${req.get('host')}/bookings/${booking._id}/cancel`
    });

    res.status(200).json({
      success: true,
      sessionId: session.id
    });
  } catch (error) {
    console.error('Erreur lors du traitement du paiement:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors du traitement du paiement'
    });
  }
};