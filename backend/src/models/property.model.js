const mongoose = require('mongoose');

const propertySchema = new mongoose.Schema({
  proprietaire: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  titre: {
    type: String,
    required: [true, 'Titre est requis'],
    trim: true
  },
  description: {
    type: String,
    required: [true, 'Description est requise']
  },
  type: {
    type: String,
    enum: ['appartement', 'maison', 'studio', 'villa', 'bureau', 'commerce'],
    required: true
  },
  statut: {
    type: String,
    enum: ['disponible', 'loué', 'maintenance', 'inactif'],
    default: 'disponible'
  },
  adresse: {
    rue: {
      type: String,
      required: true
    },
    ville: {
      type: String,
      required: true
    },
    codePostal: {
      type: String,
      required: true
    },
    pays: {
      type: String,
      required: true
    },
    coordonnees: {
      latitude: Number,
      longitude: Number
    }
  },
  caracteristiques: {
    surface: {
      type: Number,
      required: true
    },
    pieces: {
      type: Number,
      required: true
    },
    chambres: Number,
    sallesDeBain: Number,
    etage: Number,
    ascenseur: Boolean,
    parking: Boolean,
    meuble: Boolean,
    jardin: Boolean,
    balcon: Boolean,
    climatisation: Boolean,
    chauffage: String
  },
  loyer: {
    montant: {
      type: Number,
      required: true
    },
    charges: {
      type: Number,
      default: 0
    },
    garantie: Number,
    periodicite: {
      type: String,
      enum: ['mensuel', 'trimestriel', 'annuel'],
      default: 'mensuel'
    }
  },
  photos: [{
    url: String,
    principale: Boolean
  }],
  documents: [{
    type: {
      type: String,
      enum: ['diagnostic', 'assurance', 'taxe', 'autre']
    },
    nom: String,
    url: String,
    dateExpiration: Date
  }],
  disponibilite: {
    dateDisponibilite: Date,
    dureeMinimale: Number, // en mois
    dureeMaximale: Number // en mois
  },
  conditions: {
    animauxAutorises: Boolean,
    fumeurAutorise: Boolean,
    garantRequise: Boolean,
    conditionsParticulieres: String
  },
  evaluations: [{
    locataire: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    note: {
      type: Number,
      min: 1,
      max: 5
    },
    commentaire: String,
    date: {
      type: Date,
      default: Date.now
    }
  }],
  visites: [{
    date: Date,
    visiteur: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    statut: {
      type: String,
      enum: ['demandée', 'confirmée', 'annulée', 'effectuée'],
      default: 'demandée'
    }
  }],
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

// Index pour la recherche géographique
propertySchema.index({ 'adresse.coordonnees': '2dsphere' });

// Index pour la recherche textuelle
propertySchema.index({
  titre: 'text',
  description: 'text',
  'adresse.ville': 'text'
});

module.exports = mongoose.model('Property', propertySchema);