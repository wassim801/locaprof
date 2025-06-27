const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  property: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property',
    required: true
  },
  locataire: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  proprietaire: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  statut: {
    type: String,
    enum: ['en_attente', 'confirme', 'refuse', 'annule', 'termine'],
    default: 'en_attente'
  },
  dateDebut: {
    type: Date,
    required: true
  },
  dateFin: {
    type: Date,
    required: true
  },
  duree: {
    type: Number, // en mois
    required: true
  },
  loyer: {
    montantBase: {
      type: Number,
      required: true
    },
    charges: {
      type: Number,
      required: true
    },
    garantie: {
      type: Number,
      required: true
    },
    total: {
      type: Number,
      required: true
    }
  },
  paiements: [{
    type: {
      type: String,
      enum: ['loyer', 'charges', 'garantie', 'frais_agence'],
      required: true
    },
    montant: {
      type: Number,
      required: true
    },
    datePaiement: {
      type: Date,
      required: true
    },
    statut: {
      type: String,
      enum: ['en_attente', 'complete', 'echoue', 'rembourse'],
      default: 'en_attente'
    },
    stripePaymentId: String,
    referencePaiement: String
  }],
  contrat: {
    dateSignatureLocataire: Date,
    dateSignatureProprietaire: Date,
    url: String,
    statut: {
      type: String,
      enum: ['en_attente', 'signe', 'expire', 'resilie'],
      default: 'en_attente'
    }
  },
  documents: [{
    type: {
      type: String,
      enum: ['piece_identite', 'justificatif_domicile', 'justificatif_revenu', 'attestation_assurance', 'autre'],
      required: true
    },
    nom: String,
    url: String,
    dateUpload: {
      type: Date,
      default: Date.now
    },
    valide: {
      type: Boolean,
      default: false
    }
  }],
  etatDesLieux: {
    entree: {
      date: Date,
      rapport: String,
      photos: [String],
      signe: Boolean
    },
    sortie: {
      date: Date,
      rapport: String,
      photos: [String],
      signe: Boolean
    }
  },
  communications: [{
    expediteur: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    message: String,
    date: {
      type: Date,
      default: Date.now
    },
    lu: Boolean
  }],
  notifications: [{
    type: {
      type: String,
      enum: ['paiement', 'document', 'message', 'autre'],
      required: true
    },
    message: String,
    date: {
      type: Date,
      default: Date.now
    },
    lu: {
      type: Boolean,
      default: false
    }
  }],
  notes: [{
    auteur: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    contenu: String,
    date: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Middleware pour calculer automatiquement le montant total
bookingSchema.pre('save', function(next) {
  this.loyer.total = this.loyer.montantBase + this.loyer.charges;
  next();
});

// Index pour améliorer les performances des requêtes
bookingSchema.index({ property: 1, statut: 1 });
bookingSchema.index({ locataire: 1, statut: 1 });
bookingSchema.index({ proprietaire: 1, statut: 1 });

module.exports = mongoose.model('Booking', bookingSchema);