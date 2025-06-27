const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  conversation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Conversation',
    required: true
  },
  expediteur: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  destinataire: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  contenu: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['texte', 'image', 'document', 'systeme'],
    default: 'texte'
  },
  fichier: {
    url: String,
    nom: String,
    type: String,
    taille: Number
  },
  lu: {
    type: Boolean,
    default: false
  },
  dateLecture: Date,
  supprime: {
    expediteur: {
      type: Boolean,
      default: false
    },
    destinataire: {
      type: Boolean,
      default: false
    }
  }
}, {
  timestamps: true
});

const conversationSchema = new mongoose.Schema({
  participants: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  property: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property'
  },
  booking: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Booking'
  },
  dernierMessage: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message'
  },
  statut: {
    type: String,
    enum: ['active', 'archive', 'supprime'],
    default: 'active'
  },
  metadata: {
    nonLus: {
      type: Map,
      of: Number,
      default: new Map()
    },
    dernierAcces: {
      type: Map,
      of: Date,
      default: new Map()
    }
  }
}, {
  timestamps: true
});

// Index pour améliorer les performances
messageSchema.index({ conversation: 1, createdAt: -1 });
messageSchema.index({ expediteur: 1, destinataire: 1 });

conversationSchema.index({ participants: 1 });
conversationSchema.index({ property: 1 });
conversationSchema.index({ booking: 1 });

// Méthodes pour la gestion des messages non lus
conversationSchema.methods.incrementerNonLus = function(userId) {
  const nonLus = this.metadata.nonLus.get(userId.toString()) || 0;
  this.metadata.nonLus.set(userId.toString(), nonLus + 1);
  return this.save();
};

conversationSchema.methods.marquerCommeLu = function(userId) {
  this.metadata.nonLus.set(userId.toString(), 0);
  this.metadata.dernierAcces.set(userId.toString(), new Date());
  return this.save();
};

const Message = mongoose.model('Message', messageSchema);
const Conversation = mongoose.model('Conversation', conversationSchema);

module.exports = { Message, Conversation };